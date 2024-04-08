import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';


class RegisterController extends GetxController {

  final nameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;

  final ImagePicker _picker = ImagePicker();
  final Rx<XFile?> _imageFile = Rx<XFile?>(null);
  XFile? get imageFile => _imageFile.value;


  void pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _imageFile.value = pickedImage;
    }
  }

  Future<void> resgisterWithEmail(BuildContext context) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        showSnackBar(context, 'No internet connection', color: Colors.red);
        return;
      }
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constants.uri}/api/signup'),
      );

      request.fields['name'] = nameController.value.text;
      request.fields['email'] = emailController.value.text;
      request.fields['password'] = passwordController.value.text;
      request.fields['phone'] = phoneController.value.text;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile!.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200){
        AppSnackBar.show('Account created!', 'Login with the same credentials!',Colors.green);
        // showSnackBar(context, 'Account created! Login with the same credentials!', color: Colors.green);
        Get.to(LoginScreen());
      } else if (response.statusCode == 400) {
        AppSnackBar.show('Error',jsonDecode(response.body)['msg'],Colors.red);
        // showSnackBar(context, jsonDecode(response.body)['msg'],color: Colors.red);
      } else if (response.statusCode == 500) {
        AppSnackBar.show('Error',jsonDecode(response.body)['error'],Colors.red);
      } else {
        showSnackBar(context, response.body,color: Colors.red);
      }
    } catch (e) {
      GetSnackBar(title: e.toString());
    }
  }
}

class LoginController extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loginWithEmail(BuildContext context) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final response = await http.post(
          Uri.parse('${Constants.uri}/api/signin'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'email': emailController.value.text,
            'password': passwordController.value.text,
          }));
      if (response.statusCode == 200) {
        // final userData=jsonDecode(response.body);
        // final user= User.fromJson(userData);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('x-auth-token', jsonDecode(response.body)['token']);
        userProvider.setUser(response.body);
        //  await prefs.setString('user', jsonEncode(user.toMap()));
        // showSnackBar(context, 'Login Successfully', color: Colors.green);
        AppSnackBar.show('Login Successfully','Welcome to our App',Colors.green);
        Get.off(()=>HomeScreen());
      }else if (response.statusCode == 400) {
        AppSnackBar.show('Error',jsonDecode(response.body)['msg'],Colors.red);
      }else if (response.statusCode == 500) {
        AppSnackBar.show('Error',jsonDecode(response.body)['error'],Colors.red);
      }
      else {
        showSnackBar(context, response.body,color: Colors.red);
      }
    } catch (e) {
      GetSnackBar(title: e.toString());
    }
  }
}


class ImageController extends GetxController {
  var imageUrl = ''.obs;

  void setImageUrl(String url) {
    imageUrl.value = url;
  }
  @override
  void onInit() {
    super.onInit();
  }
  Future<void> getimageurl(String id) async {
    try {
      final response =
      await http.get(Uri.parse('${Constants.uri}/api/user/image/${id}'));
      if (response.statusCode == 200) {
        String image = jsonDecode(response.body)['imageUrl'];
        print('*****************1111111111$image***********************');
        setImageUrl(image);
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e.toString());
    }
  }
}



class UserDataController extends GetxController {
  RxBool isLoading = true.obs;
  User? user;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('${Constants.uri}/api/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        user = User.fromJson(userData);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('x-auth-token', userData['token']);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load user data');
    } finally {
      isLoading.value = false;
    }
  }
}



class UserController extends GetxController {
  Rx<User?> user = Rx<User?>(null);

  Future<void> getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
        return;
      }

      var tokenRes = await http.post(
        Uri.parse('${Constants.uri}/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        var userRes = await http.get(
          Uri.parse('${Constants.uri}/'),
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'x-auth-token': token},
        );

        user(User.fromJson(jsonDecode(userRes.body)));
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}


enum InternetStatus { LOADING, COMPLETED, ERROR }

class InternetChecker extends StatefulWidget {
  @override
  _InternetCheckerState createState() => _InternetCheckerState();
}

class _InternetCheckerState extends State<InternetChecker> {
  InternetStatus _status = InternetStatus.LOADING;

  @override
  void initState() {
    super.initState();
    _checkInternetStatus();
  }

  Future<void> _checkInternetStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _status = InternetStatus.ERROR;
      });
    } else {
      setState(() {
        _status = InternetStatus.COMPLETED;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internet Status'),
      ),
      body: Center(
        child: _status == InternetStatus.LOADING
            ? CircularProgressIndicator()
            : _status == InternetStatus.ERROR
            ? Text('No Internet Connection')
            : Text('Internet Connection Available'),
      ),
    );
  }
}


class ProductPosting extends GetxController {

  final idController = TextEditingController().obs;
  final productNameController = TextEditingController().obs;
  final countController = TextEditingController().obs;
  final priceController = TextEditingController().obs;


  Future<void> productdataposting(BuildContext context, String id) async {
    try {
      var response = await http.post(
        Uri.parse('${Constants.uri}/api/products/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': id,
          'productName': productNameController.value.text,
          'count': countController.value.text,
          'price': priceController.value.text,
          'datetime': DateTime.now().toIso8601String(),
        }),
      );
      print('-----------------------------${DateTime.now().toIso8601String()}-------------');
      if (response.statusCode == 200) {
        AppSnackBar.show('Successfull!', 'Your Product posted', Colors.green);
        priceController.value.clear();
        countController.value.clear();
        productNameController.value.clear();
        Navigator.pop(context);
      } else if (response.statusCode == 400) {
        AppSnackBar.show('Error', jsonDecode(response.body)['msg'], Colors.red);
        print(response.body);
      } else if (response.statusCode == 500) {
        AppSnackBar.show('Error', jsonDecode(response.body)['error'], Colors.red);
        print(response.body);
      } else {
        showSnackBar(context, response.body, color: Colors.red);
        print(response.body);
      }
    } catch (e) {
      GetSnackBar(title: e.toString());
    }
  }

}