import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Createaccount.dart';
import 'loginscreen.dart';


class ForgotPwd extends StatefulWidget {
  ForgotPwd({Key? key}) : super(key: key);

  @override
  _ForgotPwdState createState() => _ForgotPwdState();
}

class _ForgotPwdState extends State<ForgotPwd> {
  final _formKey = GlobalKey<FormState>();

  var email = "";

  final emailController = TextEditingController();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.black,
          content: Text('Password Reset Email has been sent!',
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.black,
            content: Text('No user found for that email.',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Please Enter Email';
                      } else if (!value.contains('@')) {
                        return 'Please Enter Valid Email';
                      }
                      return null;
                    },
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, otherwise false.
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        email = emailController.text;
                      });
                      //resetPassword();
                      resetPassword();
                    }
                  },
                  child: const Text('Send Email'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => {Navigator.pushAndRemoveUntil(context, PageRouteBuilder(
                        pageBuilder: (context, a, b) => LoginScreen(),
                        transitionDuration: const Duration(seconds: 0),
                      ),
                              (route) => false)
                      },
                      child: const Text('LOGIN'),
                    ),
                    TextButton(
                        onPressed: () => {
                          Navigator.pushAndRemoveUntil(context, PageRouteBuilder(
                            pageBuilder: (context, a, b) => createacc(),
                            transitionDuration:
                            const Duration(seconds: 0),
                          ),
                                  (route) => false)
                        },
                        child: const Text('SIGNUP'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
