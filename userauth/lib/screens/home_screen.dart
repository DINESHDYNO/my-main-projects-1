import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:userauth/screens/productpost.dart';
import 'package:userauth/screens/secondpage.dart';

import '../providers/user_provider.dart';
import '../services/auth_services.dart';
import 'all_user_detalis.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({Key? key}) : super(key: key);

  void signOutUser(BuildContext context) {
    AuthService().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
   // final imageUrl = user.image?.isNotEmpty ?? false ? 'http://localhost:3000/${user.image}' : 'https://media.istockphoto.com/id/1300512215/photo/headshot-portrait-of-smiling-ethnic-businessman-in-office.jpg?s=612x612&w=0&k=20&c=QjebAlXBgee05B3rcLDAtOaMtmdLjtZ5Yg9IJoiy-VY=';
   // final imageUrl = user.image?.isNotEmpty ?? false ? user.image : 'https://media.istockphoto.com/id/1300512215/photo/headshot-portrait-of-smiling-ethnic-businessman-in-office.jpg?s=612x612&w=0&k=20&c=QjebAlXBgee05B3rcLDAtOaMtmdLjtZ5Yg9IJoiy-VY=';
    return Scaffold(
      appBar: AppBar(
        actions: [
         IconButton(onPressed: (){
           Get.to(AllUserDetails());
         }, icon:  Icon(Icons.supervised_user_circle)),
          IconButton(onPressed: (){
            Get.to(ProductEnterSite(id: user.id,));
          }, icon:  Icon(Icons.add))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("User ID :"),
                  SizedBox(height: 20,),
                  Text("Name :"),
                  SizedBox(height: 20,),
                  Text("Email ID:"),
                  SizedBox(height: 20,),
                  Text("Phone Number :"),
                  SizedBox(height: 20,),
                ],
              ),
              SizedBox(width: 40,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.id),
                  SizedBox(height: 20,),
                  Text(user.name),
                  SizedBox(height: 20,),
                  Text(user.email),
                  SizedBox(height: 20,),
                  Text(user.phone),
                  SizedBox(height: 20,),
                ],
              ),
            ],
          ),
          SizedBox(height: 20,),
          Text(user.token),
          SizedBox(height: 20,),
          Center(
            child: ElevatedButton(
              onPressed: () => signOutUser(context),
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
                "Sign Out",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SecondPage(user: user.id,)));
            }, child: Text('Next')),
          )
        ],
      ),
    );
  }
}
/*
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final userdata=Get.put(UserDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx((){
        if(userdata.isLoading.isTrue){
          return Center(child: CircularProgressIndicator(),);
        }else{
          final user = userdata.user.value;
          final imageUrl = user?.image.isNotEmpty ?? false ? user?.image : 'https://media.istockphoto.com/id/1300512215/photo/headshot-portrait-of-smiling-ethnic-businessman-in-office.jpg?s=612x612&w=0&k=20&c=QjebAlXBgee05B3rcLDAtOaMtmdLjtZ5Yg9IJoiy-VY=';
          return user != null?Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Image.network(imageUrl!,fit: BoxFit.cover,)
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User ID :"),
                      SizedBox(height: 20,),
                      Text("Name :"),
                      SizedBox(height: 20,),
                      Text("Email ID:"),
                      SizedBox(height: 20,),
                      Text("Phone Number :"),
                      SizedBox(height: 20,),
                    ],
                  ),
                  SizedBox(width: 40,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.id),
                      SizedBox(height: 20,),
                      Text(user.name),
                      SizedBox(height: 20,),
                      Text(user.email),
                      SizedBox(height: 20,),
                      Text(user.phone),
                      SizedBox(height: 20,),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Text(user.token),
              SizedBox(height: 20,),
              Center(
                child: ElevatedButton(
                  onPressed: () {}*/
/*=> signOutUser(context)*//*
,
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
                    "Sign Out",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ):Center(child: Text('User data not available'));
        }
      })
    );
  }
}
*/
