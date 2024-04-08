import 'package:flutter/material.dart';
import 'package:userauth/services/getx_auth_menthod.dart';

import '../custom_textfield.dart';
import '../models/user.dart';



class ProductEnterSite extends StatefulWidget {
  final String id;
  const ProductEnterSite({super.key,required this.id});

  @override
  State<ProductEnterSite> createState() => _ProductEnterSiteState();
}

class _ProductEnterSiteState extends State<ProductEnterSite> {

  ProductPosting productPosting=ProductPosting();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top,),
          SizedBox(height: 20,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: productPosting.productNameController.value,
              hintText: 'Enter product name',
            ),
          ),
          SizedBox(height: 20,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller:productPosting.countController.value,
              hintText: 'Enter product count',
            ),
          ),
          SizedBox(height: 20,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: productPosting.priceController.value,
              hintText: 'Enter product price',
            ),
          ),
          SizedBox(height: 40,),
          Center(
            child: ElevatedButton(onPressed: (){
              productPosting.productdataposting(context,widget.id);
            }, child: Text(
              'Submit'
            )),
          )
        ],
      ),
    );
  }
}
