
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'loginscreen.dart';



showSnackBar(BuildContext context,String text){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text),));
}


class OTP_Login extends StatefulWidget {
  const OTP_Login({super.key});

  @override
  State<OTP_Login> createState() => _OTP_LoginState();
}

class _OTP_LoginState extends State<OTP_Login> {

  final _formKey = GlobalKey<FormState>();
  var phone = '';
  final phoneController = TextEditingController();

  Country selected_country=Country(phoneCode: "91",
      countryCode: "IN",
      e164Sc:0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  Future<void> phoneAuth() async{
    var verify = TextEditingController();
    FirebaseAuth firebaseAuth = await FirebaseAuth.instance;
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91"+phoneController.text.trim(),
        verificationCompleted: (PhoneAuthCredential phoneauth)async{
          await firebaseAuth.signInWithCredential(phoneauth);
        },
        verificationFailed: (error){
          throw Exception(error.message);
        },
        codeSent: (verificationid,forceResendingToken){
          showDialog(context: context,  barrierDismissible: false,
              builder: (BuildContext context){
                return AlertDialog(
                  title:const Text("OTP") ,
                  actions: [
                    TextFormField(
                      controller: verify,
                      decoration: InputDecoration(
                        hintText: "Enter the otp",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: Colors.purple),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(color: Colors.purple),
                        ),
                      ),
                    ),
                    IconButton(onPressed: () async {
                      try{
                        PhoneAuthCredential credentials = PhoneAuthProvider.
                        credential(verificationId: verificationid, smsCode: verify.text);
                        await firebaseAuth.signInWithCredential(credentials).whenComplete(() => showSnackBar(context, "verified")).then((value) =>
                           // Navigator.push(context, MaterialPageRoute(builder: (context) => const loginscreen())));
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => loginscreen())));
                      }
                      catch(e){
                        showSnackBar(context, e.toString());
                      }
                    },
                        icon: const Icon(Icons.verified,size: 30, ))
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (verificationId){}
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: InkWell(
                              onTap: (){
                                showCountryPicker(countryListTheme: const CountryListThemeData(
                                    bottomSheetHeight: 500
                                ),context: context, onSelect: (value){
                                  setState(() {
                                    selected_country=value;
                                  });
                                });
                              },
                              child: Text("${selected_country.flagEmoji}+${selected_country.phoneCode}",
                                style: const TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                        hintText: "Enter your phone number",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black)
                        ),
                      ),
                      controller: phoneController,
                      style: const TextStyle(fontSize: 20,color: Colors.black,),
                      validator: (value) {
                        if ((value!.isEmpty)) {
                          return "Phone number Field Cant Be Empty";
                        } return null;
                      }
                  ),
                ),
                ElevatedButton(onPressed: (){
                  phoneAuth();
                //  Navigator.push(context, MaterialPageRoute(builder: (context) => const loginscreen()));
                }, child: const Text("Verify Phone number"),
                ),
              ],
            ),
          )
      ) ,
    );
  }
}

