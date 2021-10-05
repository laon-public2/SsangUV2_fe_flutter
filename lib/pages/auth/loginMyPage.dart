import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/consts/textStyle.dart';
import 'package:share_product_v2/pages/mypage/MyInfo.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/CustomLinkTextContainer.dart';
import 'package:share_product_v2/widgets/CustomOnlyTextContainer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_product_v2/widgets/PageTransition.dart';

import 'myPage.dart';

class LoginMyPage extends StatefulWidget {
  @override
  _LoginMyPageState createState() => _LoginMyPageState();
}

class _LoginMyPageState extends State<LoginMyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<UserProvider>(
        builder: (_, _getMyinfo, __) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyInfoContainer(
                          username: _getMyinfo.username != null
                              ? "${_getMyinfo.username}님"
                              : "새로오셨네요!",
                          phone: "${_getMyinfo.phNum}"),
                      // CustomLinkTextContainer(
                      //   title: "나의 대여상품",
                      //   link: '/user/product',
                      // ),
                      SizedBox(height: 10.h),
                      CustomLinkTextContainer(
                        title: "나의 활동",
                        link: '/myActHistory',
                      ),
                      CustomLinkTextContainer(
                        title: "알림 내역",
                        link: '/notice',
                      ),
                      CustomLinkTextContainer(
                        title: "고객센터",
                        link: '/center',
                      ),
                      CustomLinkTextContainer(
                        title: "약관 및 정책",
                        link: '/policy',
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 13),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("앱정보", style: normal_16_000),
                            Spacer(),
                            Text(
                              "v1.0",
                              style: normal_14_primary,
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _getMyinfo.logout();
                        },
                        child: CustomOnlyTextContainer(title: "로그아웃"),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.92,
                    height: 120,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Color(0xfffff7fa),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 52,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("알림설정", style: normal_16_000),
                              Spacer(),
                              Switch(
                                value: _getMyinfo.userPush == null ? false : _getMyinfo.userPush!,
                                onChanged: (bool value) {
                                  _getMyinfo.changePush();
                                  Fluttertoast.showToast(
                                      msg: value ? "알림전송이 허용되었습니다." : "알림전송이 거부되었습니다.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Color(0xffff0066),
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 235.w),
                          child: Text(
                            "알림 설정 시 푸시 알림이 전송됩니다. 알림을 해제 시 푸시 알림이 보내지지 않습니다.",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Color(0xff999999),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      // bottomNavigationBar: BottomBar(),
    );
  }
}

class MyInfoContainer extends StatelessWidget {
  final String username;
  final String phone;

  MyInfoContainer({required this.username, required this.phone});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransitioned(
              child: MyInfo(),
              curves: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 800),
              durationRev: const Duration(milliseconds: 600),
          )
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        height: 70,
        decoration: BoxDecoration(
          color: Color(0xfffff2f7),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end:
              Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
              colors: <Color>[
                Color(0xfffff2f7),
                Color(0xffffedf5)
              ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 48,
              height: 48,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(48),
              //   color: Colors.grey,
              // ),
              child: Consumer<UserProvider>(
                builder: (_, _getMyinfo, __) {
                  return _getMyinfo.userProfileImg != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            "http://115.91.73.66:15066/assets/images/user/${_getMyinfo.userProfileImg}",
                            height: 100.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(Icons.account_circle,
                          color: Colors.grey, size: 50.0);
                },
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${this.username}",
                        style: bold_16_000,
                      ),
                      Text(
                        " 반가워요!",
                        style: normal_16_000,
                      ),
                    ],
                  ),
                  Text(
                    this.phone,
                    style: normal_14_999,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.navigate_next,
              color: Colors.black,
              size: 24.w,
            ),
          ],
        ),
      ),
    );
  }
}
