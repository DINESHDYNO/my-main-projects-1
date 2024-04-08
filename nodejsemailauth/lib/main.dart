
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nodejsemailauth/screens/auth/auth_screen.dart';

void main() async {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: AuthScreen(),
  ));
}
