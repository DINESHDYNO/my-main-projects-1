import 'package:flutter/material.dart';

import 'contants.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileScreenlayout;
  final Widget webScreenlayout;
  const ResponsiveLayout({super.key, required this.mobileScreenlayout, required this.webScreenlayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraine){
      if(constraine.maxWidth>webscreensize){
        return widget.webScreenlayout;
      }
      return widget.mobileScreenlayout;
    });
  }
}
