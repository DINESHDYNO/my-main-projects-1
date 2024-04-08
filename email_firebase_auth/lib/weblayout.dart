import 'package:flutter/material.dart';



class WebscreenLayout extends StatefulWidget {
  const WebscreenLayout({super.key});

  @override
  State<WebscreenLayout> createState() => _WebscreenLayoutState();
}

class _WebscreenLayoutState extends State<WebscreenLayout> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('webscreenlayout'),),
    );
  }
}
