import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:share_product_v2/pages/chat/CustomerMessage.dart';

class FCMModel with ChangeNotifier {
  String mbToken;
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message 데이터 메세지 캡쳐
      final dynamic data = message['data'];
      print(data);
    }

    if (message.containsKey('notification')) {
      // Handle notification message 알림 메세지 캡쳐
      final dynamic notification = message['notification'];
      print(notification);
    }

    // Or do other work.
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FCMModel() {
    if (Platform.isIOS) _iosPermission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   Navigator.push(context, MaterialPageRoute(
        //       builder: (context) => CustomerMessage(
        //           uuid,
        //           productIdx,
        //           title,
        //           category,
        //           productOwner,
        //           price,
        //           pic,
        //           status,
        //           receiverIdx
        //       )
        //   ));
        // });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  Future<void> getMbToken() async {
    mbToken = await _firebaseMessaging.getToken();
    print("fcm 토근이여 $mbToken");
  }

  void _iosPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}