import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:userauth/providers/user_provider.dart';
import 'package:userauth/screens/home_screen.dart';
import 'package:userauth/screens/signup_screen.dart';
import 'package:userauth/services/auth_services.dart';
import 'package:userauth/utils/constants.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Node Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.homescreen,
      getPages: getPages,
      home: Provider.of<UserProvider>(context).user.token.isEmpty ? const SignupScreen() :  HomeScreen(),
    );
  }
}
