import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_firebase_auth/user_models.dart' as model;
import 'package:email_firebase_auth/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';



final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;


// class AuthMethods {
//   Future<model.User>getUserDetails() async {
//     User currentUser=_auth.currentUser!;
//     DocumentSnapshot snap = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get();
//     return model.User.fromSnap(snap);
//   }
//
//
//   SignUpUser(
//       {required String username,
//       required String phone,
//       required String email,
//       required password}) async {
//     String res = "some error Occurred";
//     try {
//       if (username.isNotEmpty || phone.isNotEmpty || email.isNotEmpty || password.isNotEmpty) {
//         UserCredential cred = await _auth.createUserWithEmailAndPassword(
//             email: email, password: password);
//         model.User _user = model.User(username: username, uid: cred.user!.uid, email: email, phone: phone);
//         print('User data to be saved: ${_user.toJson()}');
//
//         await _firestore.collection('users').doc(cred.user!.uid).set(_user.toJson());
//         res = "success";
//       }
//     } catch (e) {
//       print('Error in SignUpUser: $e');
//       return e.toString();
//     }
//     return res;
//   }
//
//
//   loginUser({
//     required String email,required String password
// }) async {
//     String res = "some error Occurred";
//     try{
//       if(email.isNotEmpty||password.isNotEmpty){
//         await _auth.signInWithEmailAndPassword(email: email, password: password);
//         res="success";
//       }
//     }catch(e){
//       return e.toString();
//     }
//     return res;
//   }
// }

class AuthMethods {
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<String> userData(BuildContext context) async {
    model.User? user = Provider.of<UserProvider>(context, listen: false).getUser;
    String res = "some error Occurred";
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      Map<String, dynamic> data = {
        'username': user?.username,
        'phone': user?.phone,
      };
      await firestore.collection('chatRoom').doc(user?.username).set(data);
      res = "success";
    } catch (e) {
      // Print any error that occurs
      print(e.toString());
    }
    // Return the result
    return res;
  }


  Future<String> signUpUser({required String username, required String phone, required String email, required String password,}) async {
    String res = "some error Occurred";
    try {
      if (username.isNotEmpty && phone.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        model.User _user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          phone: phone,
        );
        print('User data to be saved: ${_user.toJson()}');

        await _firestore.collection('users').doc(cred.user!.uid).set(_user.toJson());
        res = "success";
      }
    } catch (e) {
      print('Error in signUpUser: $e');
      return e.toString();
    }
    return res;
  }

  Future<String> phoneAuth({required String username, required String phone}) async {
    try {
      if (username.isNotEmpty && phone.isNotEmpty) {
        PhoneVerificationCompleted verificationCompleted =
            (PhoneAuthCredential phoneAuthCredential) async {
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
        };
        PhoneVerificationFailed verificationFailed =
            (FirebaseAuthException authException) {
          print('Phone verification failed. Code: ${authException.code}. Message: ${authException.message}');
        };

        PhoneCodeSent codeSent =
            (String verificationId, [int? forceResendingToken]) async {
          String verificationCode = '123456';
          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: verificationCode);
          await FirebaseAuth.instance.signInWithCredential(credential);
        };

        PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
            (String verificationId) {
        };

        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
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

  Future<String> loginUser({required String email, required String password,}) async {
    String res = "some error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      }
    } catch (e) {
      print('Error in loginUser: $e');
      return e.toString();
    }
    return res;
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error in logout: $e');
    }
  }

}


