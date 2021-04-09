import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/bannerProvider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/utils/SharedPref.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat/CustomerMessage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage(){
    Navigator.of(context).pushReplacementNamed('/main');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  // void initializeFlutterFire() async {
  //   try {
  //     // Wait for Firebase to initialize and set `_initialized` state to true
  //     await Firebase.initializeApp();
  //     setState(() {
  //       // _initialized = true;
  //       startTime();
  //     });
  //   } catch (e) {
  //     // Set `_error` state to true if Firebase initialization fails
  //     setState(() {
  //       // _error = true;
  //     });
  //   }
  // }

  void setAuthToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.get("access_token");
    String reToken = pref.get("refresh_token");
    print("token : $token");
    print("reToken : $reToken");
    if (token != null && token != "" && reToken != null && reToken != "") {
      await Provider.of<UserProvider>(context, listen: false)
          .refreshToken(reToken);
      Provider.of<UserProvider>(context, listen: false).setAccessToken(token);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "쌩유",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 36.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "우리 모두 함께 참여하는 생활의 모든 공유",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [1, 2, 3, 4, 5].map((e) {
                  return Container(
                    width: 60,
                    child: Image.asset(
                      "assets/loading$e.gif",
                      width: 36,
                      height: 36,
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
