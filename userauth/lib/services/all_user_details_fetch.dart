import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import '../models/all_user_details.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class FetchAllUserDetails extends GetxController {
  RxBool isLoading = true.obs;
  RxList<AllUserData> allUserData = RxList<AllUserData>();

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      isLoading.value=true;
      final response = await http.get(
        Uri.parse('${Constants.uri}/api/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<AllUserData> users = data.map((e) => AllUserData.fromJson(e)).toList();
        allUserData.value=users;
        print('UserData: ${response.body}');
        AppSnackBar.show('Succesfull', 'Users Details', Colors.green);
      }
      else{
        AppSnackBar.show('Error', 'error', Colors.green);
      }
    } catch (e) {
      AppSnackBar.show('Error', e.toString(), Colors.green);
      print(e.toString());
    }finally{
      isLoading.value=false;
  }
  }
}
