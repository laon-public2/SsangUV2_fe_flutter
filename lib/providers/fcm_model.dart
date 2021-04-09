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

  // FCMModel(BuildContext context) {
  //   if (Platform.isIOS) _iosPermission();
  //
  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print('on message $message');
  //     },
  //     onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
  //     // onBackgroundMessage: Platform.isIOS ? null : (Map<String, dynamic> message)async {
  //     //   print('on background $message');
  //     // },
  //     onResume: (Map<String, dynamic> message) async {
  //       print('on resume $message');
  //       Platform.isIOS ?
  //       SchedulerBinding.instance.addPostFrameCallback((_) {
  //         Navigator.push(context, MaterialPageRoute(
  //             builder: (context) => CustomerMessage(
  //                 message['uuid'],
  //                 message['productIdx'],
  //                 message['title'],
  //                 message['category'],
  //                 message['productOwner'],
  //                 message['price'],
  //                 message['pic'],
  //                 message['status'],
  //                 message['receiverIdx'],
  //                 message['senderFcm'],
  //                 message['receiverFcm'],
  //                 message['senderIdx'],
  //             )
  //         ));
  //       }):
  //       SchedulerBinding.instance.addPostFrameCallback((_) {
  //         Navigator.push(context, MaterialPageRoute(
  //             builder: (context) => CustomerMessage(
  //               message['data']['uuid'],
  //               message['data']['productIdx'],
  //               message['data']['title'],
  //               message['data']['category'],
  //               message['data']['productOwner'],
  //               message['data']['price'],
  //               message['data']['pic'],
  //               message['data']['status'],
  //               message['data']['receiverIdx'],
  //               message['data']['senderFcm'],
  //               message['data']['receiverFcm'],
  //               message['data']['senderIdx'],
  //             )
  //         ));
  //       });
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print('on launch $message');
  //     },
  //   );
  // }

  Future<void> getMbToken() async {
    mbToken = await _firebaseMessaging.getToken();
    print("fcm 토근이여 $mbToken");
    notifyListeners();
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