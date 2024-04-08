import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../services/getx_auth_menthod.dart';

class SecondPage extends StatelessWidget {
   String user;
   SecondPage({super.key,required this.user});

  final  imageController = Get.put(ImageController());
  @override
  Widget build(BuildContext context) {
    imageController.getimageurl(user);
    return  Scaffold(
      body: Center(
        child: Obx(() {
          if (imageController.imageUrl.isEmpty) {
            return CircularProgressIndicator();
          } else {
            return Text(imageController.imageUrl.value.toString())/*Image.network(
              imageController.imageUrl.value,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            )*/;
          }
        }),
      ),
    );
  }
}
