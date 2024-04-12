import 'package:email_firebase_auth/user_auth_getx.dart';
import 'package:flutter/material.dart';

import 'auth_methods.dart';
import 'homepage.dart';
import 'loginscreen.dart';

void showSnackBar(BuildContext context, String text) {
  final controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: ScaffoldMessenger.of(context),
  );

  final animation = Tween(begin: const Offset(0, 1), end: Offset(0, 0)).animate(controller);

  controller.forward();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: SlideTransition(
        position: animation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.green,
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(text),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );

  Future.delayed(const Duration(seconds: 1) + controller.duration!, () {
    controller.reverse();
  });
}


class createacc extends StatefulWidget {
  @override
  State<createacc> createState() => _createaccState();
}

class _createaccState extends State<createacc> {

  RegisterWithGetX registerWithGetX=RegisterWithGetX();

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isloading=false;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  singUpUser() async {
    setState(() {
      isloading = true;
    });
    String name = nameController.text;
    String phone = phoneController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      showSnackBar(_scaffoldKey.currentContext!, 'Passwords and Confirm Password do not match');
      return;
    }

    if (_formKey.currentState!.validate()) {
      String result = await AuthMethods().signUpUser(
        username: name,
        phone: phone,
        email: email,
        password: password,
      );

      if (result == 'success') {
        setState(() {
          isloading = false;
        });
        showSnackBar(_scaffoldKey.currentContext!, result);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Home()));
      } else {
        showSnackBar(_scaffoldKey.currentContext!, result);
        setState(() {
          isloading = false;
        });
      }
      print(result);
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFF1E88E5),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                const Center(
                  child: Text(
                    'Create Your Account',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        'User Name',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null ||
                          !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter your name'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        'Phone',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: phoneController,
                    validator: (value) {
                      if (value == null ||
                          !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Please Enter Phone Number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter your Phone no'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        "Email Adress ( e.g., example@example.com )",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please Enter a valid email address';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Enter your email ',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        'Password',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter your password'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        'Confirm Password',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter your Confirm Password'),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: isloading?const CircularProgressIndicator(
                    color: Colors.white,
                  ): ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 122, vertical: 14),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      backgroundColor: const Color(0xFF0D47A1),
                    ),
                    onPressed:
                        singUpUser /*() {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            name = nameController.text;
                            phone = phoneController.text;
                            email = emailController.text;
                            password = passwordController.text;
                            confirmPassword = confirmPasswordController.text;
                            Navigator.pop(context);
                          });
                        }
                      },*/
                    ,
                    child: const Text(
                      'Create account',
                      style: TextStyle(fontSize: 18, letterSpacing: 0.5),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 70,
                      ),
                      const Text(
                        'Already have a accounts?',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      TextButton(
                          onPressed: () => {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            const LoginScreen(),
                                    transitionDuration: const Duration(seconds: 0),
                                  ),
                                )
                              },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
