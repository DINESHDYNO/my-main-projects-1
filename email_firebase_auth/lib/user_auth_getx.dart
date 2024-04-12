import 'dart:ffi';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:email_firebase_auth/user_models.dart' as model;

import 'loginscreen.dart';


//Getx use mvc method Model,View ,Controller


class PhoneNumberAuth extends GetxController{

  final userNumber=TextEditingController().obs;
  final phoneNumber=TextEditingController().obs;
  final otpCode=TextEditingController().obs;

  final secondFocusNode = FocusNode().obs;
  final thirdFocusNode = FocusNode().obs;
  final fourthFocusNode = FocusNode().obs;


  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc:0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  Future<String> phoneAuth() async {
    try {
      if (userNumber.value.text.isNotEmpty && phoneNumber.value.text.isNotEmpty) {
        verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
        }
        verificationFailed(FirebaseAuthException authException) {
          print('Phone verification failed. Code: ${authException.code}. Message: ${authException.message}');
        }

        codeSent(String verificationId, [int? forceResendingToken]) async {
          String verificationCode = otpCode.value.text;
          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: verificationCode);
          await FirebaseAuth.instance.signInWithCredential(credential);
          Get.to(() => const LoginScreen());
        }

        codeAutoRetrievalTimeout(String verificationId) {
        }

        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber.value.text,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
          timeout: Duration(seconds: 60),
        );

        return "Verification code sent";
      } else {
        return "Please enter valid username and phone number";
      }
    } catch (e) {
      print('Error during phone authentication: ${e.toString()}');
      return "An error occurred during phone authentication";
    }
  }
}

class RegisterWithGetX extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final userName = TextEditingController().obs;
  final userPhone = TextEditingController().obs;
  final userEmail = TextEditingController().obs;
  final userPassword = TextEditingController().obs;
  final userConfirmPassword = TextEditingController().obs;

  Future<String> signUpUser() async {
    String res = "some error Occurred";
    try {
      if (userName.value.text.isNotEmpty &&
          userPhone.value.text.isNotEmpty &&
          userEmail.value.text.isNotEmpty &&
          userPassword.value.text.isNotEmpty &&
          userConfirmPassword.value.text.isNotEmpty) {
        if (userPassword.value.text == userConfirmPassword.value.text) {
          UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: userEmail.value.text,
            password: userPassword.value.text,
          );
          model.User _user = model.User(
            username: userName.value.text,
            uid: cred.user!.uid,
            email: userEmail.value.text,
            phone: userPhone.value.text,
          );
          print('User data to be saved: ${_user.toJson()}');

          await _firestore.collection('users').doc(cred.user!.uid).set(_user.toJson());
          res = "success";
        } else {
          res = "Passwords do not match";
        }
      } else {
        res = "Please fill in all fields";
      }
    } catch (e) {
      print('Error in signUpUser: $e');
      return e.toString();
    }
    return res;
  }
}


class Login extends GetxController{
  final _auth = FirebaseAuth.instance;

  final userEmail =TextEditingController().obs;
  final userPassword=TextEditingController().obs;


  Future<String> login()async {
    String res = "some error Occurred";
    try{
      if(userEmail.value.text.isNotEmpty&&userPassword.value.text.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: userEmail.value.text, password: userPassword.value.text);
        res='sucess';
      }
    }catch(e){
      print('Error in signInUser: $e');
      return e.toString();
    }
    return res;
  }

}


class LogoutController extends GetxController {
  final _auth = FirebaseAuth.instance;

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}

// class UserGet extends GetxController{
//   final _auth = FirebaseAuth.instance;
//   final _firestore=FirebaseFirestore.instance;
//
//   Future<model.User> getUserDetails() async {
//     User currentUser = _auth.currentUser!;
//     DocumentSnapshot snap = await _firestore
//         .collection('users')
//         .doc(_auth.currentUser!.uid)
//         .get();
//     return model.User.fromSnap(snap);
//   }
// }
class UserGet extends GetxController {
  Future<model.User> getUserDetails() async {
    User currentUser = FirebaseService.auth.currentUser!;
    DocumentSnapshot snap = await FirebaseService.firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();
    return model.User.fromSnap(snap);
  }
}


class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static FirebaseAuth get auth => _auth;
  static FirebaseFirestore get firestore => _firestore;
}
