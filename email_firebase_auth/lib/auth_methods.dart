import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_firebase_auth/user_models.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';



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
    DocumentSnapshot snap = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String username,
    required String phone,
    required String email,
    required String password,
  }) async {
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

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
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
}

