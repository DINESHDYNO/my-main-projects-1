
import 'package:email_firebase_auth/homepage.dart';
import 'package:email_firebase_auth/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'loginscreen.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(const MyApp());
  } catch (e) {
    print('Error initializing Firebase or running the app: $e');
    // Handle the error as needed
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UserProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.active){
            if(snapshot.hasData){
              return const Home();
            }else if(snapshot.hasError){
              return Center(child: Text('${snapshot.error}'));
            }
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          return const LoginScreen();
        })
        //loginscreen(),
      ),
    );
  }
}
