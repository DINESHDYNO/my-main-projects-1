import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String email;
  final String phone;

  User(
      {required this.username, required this.uid, required this.email, required this.phone});


  Map<String, dynamic> toJson() =>
      {
        "username": username,
        "uid": uid,
        "email": email,
        "phone": phone
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      phone: snapshot['phone'],
      email: snapshot['email'],
    );
  }

}
