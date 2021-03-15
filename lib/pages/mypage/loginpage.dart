import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/mapProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage_not_use extends StatelessWidget {
  SharedPreferences pref;
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      pref = await SharedPreferences.getInstance();
    });
    this.context = context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: body(context)),
    );
  }

  Widget body(context) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(top: 10.h, right: 10.h, bottom: 24.h),
            child: InkWell(
              child: Icon(Icons.close),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          swipeTutorial(context),
          Spacer(),
          loginButtons()
        ],
      ),
    );
  }

  Widget swipeTutorial(context) {
    int _current = 0;

    final List<String> images = [
      'assets/idea.png',
      'assets/mobile.png',
      'assets/social.png'
    ];

    return Column(children: [
      CarouselSlider(
        options: CarouselOptions(
            height: 400.h,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              // setState(() {
              _current = index;
              // }
              // );
            }),
        items: images.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: 360.h,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.asset(
                  i,
                ),
              );
            },
          );
        }).toList(),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: images.map((url) {
          int index = images.indexOf(url);
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index ? Color(0xffff0066) : Color(0xffaaaaaa),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  Widget loginButtons() {
    return Padding(
      padding: EdgeInsets.only(bottom: 33.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: Material(
              color: Color(0xfff7f7f7), // button color
              child: InkWell(
                splashColor: Color(0xff999999), // inkwell color
                child: SizedBox(
                    width: 52.h,
                    height: 52.h,
                    child: Padding(
                      padding: EdgeInsets.all(15.h),
                      child: Image.asset(
                        "assets/apple.png",
                        width: 24,
                        height: 24,
                      ),
                    )),
                onTap: () {
                  //appleLogin();
                },
              ),
            ),
          ),
          SizedBox(
            width: 20.h,
          ),
          ClipOval(
            child: Material(
              color: Color(0xffffcc00), // button color
              child: InkWell(
                splashColor: Color(0xffDFB714), // inkwell color
                child: SizedBox(
                    width: 52.h,
                    height: 52.h,
                    child: Padding(
                      padding: EdgeInsets.all(12.h),
                      child: Image.asset(
                        "assets/kakao.png",
                        width: 24,
                        height: 24,
                      ),
                    )),
                onTap: () {
                  // kakaoLogin();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  // 카카오 로그인 시 사용
  // void kakaoLogin() async {
  //   print("kakao Login");
  //
  //   try {
  //     final installed = await isKakaoTalkInstalled();
  //     // final authCode = installed ? await AuthCodeClient.instance.requestWithTalk() : await AuthCodeClient.instance.request();
  //     // final authCode = await AuthCodeClient.instance.request();
  //     AuthCodeClient.instance.requestWithTalk().then((value) {
  //       print(1);
  //       print(value);
  //     });
  //     // print(authCode);
  //     // AccessTokenResponse token = await AuthApi.instance.issueAccessToken(authCode);
  //     // AccessTokenStore.instance.toStore(token);
  //     //
  //     // if( token.accessToken != null ) {
  //     //   await Provider.of<UserProvider>(context, listen: false).getAccessToken(token.accessToken);
  //     //   Navigator.of(context).pop();
  //     // }
  //   //
  //   } on KakaoAuthException catch (e) {
  //       print(e);
  //   }
  //
  //
  //     // ========================================================================
  //     // 주소 계정과 동기화
  //     // ========================================================================
  //     String position = pref.getString("address") ?? "NONE";
  //
  //     double latitude = double.parse(position.split(",")[0]);
  //     double longitude = double.parse(position.split(",")[1]);
  //
  //     String address =
  //     await Provider.of<MapProvider>(context, listen: false)
  //         .getAddress(latitude, longitude);
  //
  //     Provider.of<UserProvider>(context, listen: false).setAddress(context, address, "");
  //     // ========================================================================
  //
  //     Navigator.of(context).pop();
  //   }
  //   // final FlutterKakaoLogin kakaoSignIn = new FlutterKakaoLogin();
  //   // KakaoLoginResult result = await kakaoSignIn.logIn();
  //   // print("12312321");
  //   // if (result.status == KakaoLoginStatus.loggedIn){
  //   //   KakaoToken token = await (kakaoSignIn.currentToken);
  //   //   final accesstoken = token.accessToken;
  //   //   print(token);
  //   //   print(accesstoken);
  //   //
  //   //   await Provider.of<UserProvider>(context, listen: false).getAccessToken(accesstoken);
  //   //
  //   //   Navigator.of(context).pop();
  //   // }
  //   // }
  //
  // void appleLogin() async {
  //   print("appleLogin");
  //   print(SignInWithApple);
  //   final credential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //
  //   );
  //
  //   print(credential);
  //   print(credential.authorizationCode);
  //   print(credential.identityToken);
  // }

}
