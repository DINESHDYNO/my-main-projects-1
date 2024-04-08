import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userauth/services/all_user_details_fetch.dart';

class AllUserDetails extends StatelessWidget {
  AllUserDetails({Key? key}) : super(key: key);

  final FetchAllUserDetails alluserdata = Get.put(FetchAllUserDetails());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (alluserdata.isLoading==true) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: alluserdata.allUserData.length,
            itemBuilder: (context, index) {
              var user = alluserdata.allUserData[index];
              return ListTile(
                leading: Text(index.toString()),
                title: Text(user.name.toString()),
                subtitle: Text(user.email.toString()),
                trailing: Text(user.phone.toString()),
              );
            },
          );
        }
      }),
    );
  }
}
