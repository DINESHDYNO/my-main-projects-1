import 'package:flutter/material.dart';

import 'loginscreen.dart';




class MobilescreenLayout extends StatefulWidget {
  const MobilescreenLayout({super.key});

  @override
  State<MobilescreenLayout> createState() => _MobilescreenLayoutState();
}

class _MobilescreenLayoutState extends State<MobilescreenLayout> {
  @override
  Widget build(BuildContext context) {
    return const loginscreen();
  }
}
