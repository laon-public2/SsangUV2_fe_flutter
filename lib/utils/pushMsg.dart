import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:share_product_v2/providers/userController.dart';

class PushManager {
  static final PushManager _manager = PushManager._internal();

  UserController userController = Get.find<UserController>();
  final _firebaseMessaging = FirebaseMessaging.instance;

  factory PushManager() {
    return _manager;
  }

  PushManager._internal() {
    // 초기화 코드ㅂ
  }

  void _requestIOSPermission() {
    _firebaseMessaging.requestPermission(
        // IosNotificationSettings(sound: true, badge: true, alert: true)
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,

    );

    // _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
  }

  void registerToken(BuildContext context) {
    if (Platform.isIOS) {
      _requestIOSPermission();
    }

    _firebaseMessaging.getToken().then((token) {
      print('파베 $token');
      userController.userFBtoken.value = token!;
    });
  }

  void listenFirebaseMessaging(BuildContext context) {
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     // Triggered if a message is received whilst the app is in foreground
    //     print('on message $message');
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     // Triggered if a message is received whilst the app is in background
    //     print('on resume $message');
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     // Triggered if a message is received if the app was terminated
    //     print('on launch $message');
    //   },
    // );
  }
}
