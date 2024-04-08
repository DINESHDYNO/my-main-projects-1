import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_firebase_auth/user_models.dart' as model;
import 'package:email_firebase_auth/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class home1 extends StatefulWidget {
  const home1({super.key});

  @override
  State<home1> createState() => _home1State();
}

class _home1State extends State<home1> {


  String username = '';
  String email = '';
  String phone = '';
  String uid = '';

  Future<void> getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      isLoading = false;
      username = (snap.data() as Map<String, dynamic>)['username'];
      email = (snap.data() as Map<String, dynamic>)['email'];
      phone = (snap.data() as Map<String, dynamic>)['phone'];
      uid = (snap.data() as Map<String, dynamic>)['uid'];
    });
  }
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getUsername();
    addData();
  }
  addData() async {
    UserProvider userProvider=Provider.of(context,listen: false);
    await userProvider.refreshUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
  //  print("--------$user-------------");
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Username: ${user?.username}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Email: ${user?.email}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Phone: ${user?.phone}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'UID: ${user?.uid}',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        )
      ),
    );
  }
}
