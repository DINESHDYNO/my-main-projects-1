import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../custom_textfield.dart';
import '../services/auth_services.dart';
import '../services/getx_auth_menthod.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final AuthService authService = AuthService();
  XFile? _imageFile;
  RegisterController registerController=Get.put(RegisterController());


  void signupUser() {
    authService.signUpUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      phone: phoneController.text,
      image: _imageFile?.path ?? '',
    );
    print('--------------$_imageFile------------');
  }
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(()=>Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top,),
            const Text(
              "Signup",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            // GestureDetector(
            //   onTap: _pickImage,
            //   child: CircleAvatar(
            //     radius: 50,
            //     child: _imageFile != null
            //         ? Image.file(File(_imageFile!.path))
            //         : Icon(Icons.add, size: 40),
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                registerController.pickImage();
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: registerController.imageFile != null
                    ? FileImage(File(registerController.imageFile!.path))
                    : null,
                child: registerController.imageFile == null
                    ? const Icon(Icons.add, size: 40)
                    : null,
              ),
            ),
            SizedBox(height: 30,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: registerController.nameController.value,
                hintText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: registerController.phoneController.value,
                hintText: 'Enter your phone',
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: registerController.emailController.value,
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: registerController.passwordController.value,
                hintText: 'Enter your password',
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: (){
                registerController.resgisterWithEmail(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width / 2.5, 50),
                ),
              ),
              child: const Text(
                "Sign up",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                    context,'/login'
                );
              },
              child: const Text('Login User?'),
            ),
          ],
        ))
      ),
    );
  }
}
