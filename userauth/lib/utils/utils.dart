import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;


void showSnackBar(BuildContext context, String text,{required Color color}) {
  final snackBar = SnackBar(
    content: Text(text),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
    margin: const EdgeInsets.only(top: 70, left: 20, right: 20,bottom: 20),
    duration: const Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
class AppSnackBar{
  static void show(String title, String message,Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      backgroundColor: color,
      colorText: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
    );
  }
}
void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  Color snackBarColor = response.statusCode == 200 ? Colors.green : Colors.red;
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.body)['msg'],color: snackBarColor);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)['error'],color: snackBarColor);
      break;
    default:
      showSnackBar(context, response.body,color: snackBarColor);
  }
}
