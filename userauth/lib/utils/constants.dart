import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:userauth/screens/home_screen.dart';
import 'package:userauth/screens/login_screen.dart';
import 'package:userauth/screens/signup_screen.dart';

class Constants {
  static String uri = 'http://192.168.174.209:3000';
}
// class Routes {
//   static final Map<String, WidgetBuilder> routes = {
//     '/login': (context) =>  LoginScreen(),
//     '/signup': (context) =>  SignupScreen(),
//   };
// }

class Routes {
  static String homescreen = '/';
  static String loginscreen = '/login';
  static String signupscreen = '/signup';
}

final getPages = [
    GetPage(
      name: Routes.homescreen,
      page: () =>  HomeScreen(),
    ),
  GetPage(
    name: Routes.loginscreen,
    page: () =>  LoginScreen(),
  ),
  GetPage(
    name: Routes.signupscreen,
    page: () =>  SignupScreen(),
  ),
];
