import 'package:email_firebase_auth/user_models.dart';
import 'package:flutter/material.dart';

import 'auth_methods.dart';


class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User? get getUser => _user;

  Future<void> refreshUser() async {
    try {
      User user = await _authMethods.getUserDetails();
      _user = user;
      notifyListeners();
    } catch (e) {
      print('Error in referenceUser: $e');
    }
  }
}