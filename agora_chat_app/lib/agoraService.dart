//
// import 'package:flutter/material.dart';
//
//
//
// class AgoraService {
//   static final AgoraService _instance = AgoraService._internal();
//   factory AgoraService() => _instance;
//
//   AgoraService._internal();
//
//   final String agoraAppId = 'YOUR_AGORA_APP_ID';
//   bool _initialized = false;
//
//   Future<void> initialize() async {
//     if (!_initialized) {
//       await AgoraRtcEngine.create(agoraAppId);
//       await AgoraRtcEngine.enableVideo();
//       _initialized = true;
//     }
//   }
//
//   void dispose() {
//     AgoraRtcEngine.leaveChannel();
//     AgoraRtcEngine.destroy();
//   }
// }
