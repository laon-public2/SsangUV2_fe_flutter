import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/mainpage.dart';
import 'package:share_product_v2/providers/bannerController.dart';
import 'package:share_product_v2/providers/productController.dart';
import 'package:share_product_v2/providers/userController.dart';
import 'package:share_product_v2/utils/SharedPref.dart';
import 'package:share_product_v2/widgets/splashAni.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'chat/CustomerMessage.dart';

class SplashScreen extends StatelessWidget {
  Map<Permission, PermissionStatus>? statuses;

  startTime(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2)).then((value) { navigationPage(context); });

  }

  closeApp() async {
    await Future.delayed(Duration(seconds: 3)).then((value) { pop(); });
  }

  static Future<void> pop({bool? animated}) async {
    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', animated);
  }

  Future<void> navigationPage(BuildContext context) async {
    // Route route = MaterialPageRoute(builder: (context) => MainPage());
    // Navigator.popUntil(context, ModalRoute.withName('/login'));
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => MainPage(),
    //   ),
    //       (route) => false,
    // );
    try {
      await Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MainPage()));
      // Navigator.pushReplacement(context, route);
      // Navigator.of(context).push(
      //   PageTransition(
      //     child: MainPage(),
      //     type: PageTransitionType.fade,
      //   )
      // );
    }
    catch(e){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage()));
    }
  }

  Future<void> permission(BuildContext context) async {
    statuses = await [Permission.location].request();

    await Future.delayed(Duration(seconds: 1)).then((value) async {
      // print(statuses![Permission.location]);
      if (statuses![Permission.location] == PermissionStatus.granted) {
        // Either the permission was already granted before or the user just granted it.
        startTime(context);
      }
      else if(statuses![Permission.location] == PermissionStatus.denied){
        await Fluttertoast.showToast(
          msg: "쌩유 서비스의 이용을 위해 위치정보 제공 동의를 진행해주세요.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xffff0066),
          textColor: Colors.white,
          fontSize: 16.0,
          timeInSecForIosWeb: 10,
        );
        closeApp();
      }
      else if(statuses![Permission.location] == PermissionStatus.permanentlyDenied){
        await Fluttertoast.showToast(
          msg: "쌩유 서비스의 이용을 위해 위치정보 제공 동의를 진행해주세요.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xffff0066),
          textColor: Colors.white,
          fontSize: 16.0,
          timeInSecForIosWeb: 10,
        );
        closeApp();
      }
    });


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

  // void setAuthToken() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String token = pref.get("access_token").toString();
  //   String reToken = pref.get("refresh_token").toString();
  //   print("token : $token");
  //   print("reToken : $reToken");
  //   if (token != null && token != "" && reToken != null && reToken != "") {
  //     await Provider.of<UserProvider>(context, listen: false)
  //         .refreshToken(reToken);
  //     Provider.of<UserProvider>(context, listen: false).setAccessToken(token);
  //   } else {
  //     return;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    permission(context);
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
              child: SplashAni(),
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [1, 2, 3, 4, 5].map((e) {
              //     return Container(
              //       width: 60,
              //       child: SplashAni(),
              //     );
              //   }).toList(),
              // ),
            )
          ],
        ),
      ),
    );
  }
}
