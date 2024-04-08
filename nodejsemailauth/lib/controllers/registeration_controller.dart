import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../screens/home.dart';
import '../utils/api_endpoints.dart';

class RegisterationController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> registerWithEmail() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.registerEmail);
      Map body = {
        'name': nameController.text,
        'email': emailController.text.trim(),
        'password': passwordController.text
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        // var token = json['Token'];
        // final SharedPreferences? prefs = await _prefs;
        // await prefs?.setString('token', token);
        print('--------$json------------');
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        Get.off(HomeScreen());
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
      }
    } catch (e) {
      print(e.toString());
      // Get.back();
      // showDialog(
      //     context: Get.context!,
      //     builder: (context) {
      //       return SimpleDialog(
      //         title: Text('Error'),
      //         contentPadding: EdgeInsets.all(20),
      //         children: [Text(e.toString())],
      //       );
      //     });
    }
  }
}
