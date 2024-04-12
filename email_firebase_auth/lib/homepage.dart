import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_firebase_auth/user_models.dart' as model;
import 'package:email_firebase_auth/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_methods.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _home1State();
}

class _home1State extends State<Home> {

  final AuthMethods _authMethods = AuthMethods();

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async {
            await _authMethods.logout();
          }, icon: Icon(Icons.logout)),
        ],
      ),
      drawer: Drawer(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top,),
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
            SizedBox(height: 50,),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 3
                )
              ]
            ),
            child: TextFormField(
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.search),
                border: InputBorder.none
              ),
            )
          ),
          ElevatedButton(
            onPressed: () async {
              String result = await _authMethods.userData(context);
              print(result); // Print the result of the operation

              // Show a dialog based on the result
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Upload Result'),
                    content: Text(result == 'success' ? 'Upload successful' : 'Upload failed'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Upload Data'),
          )
        ],
      ),
    );
  }
}
