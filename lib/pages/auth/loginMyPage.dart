import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/consts/textStyle.dart';
import 'package:share_product_v2/pages/mypage/MyInfo.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/CustomLinkTextContainer.dart';
import 'package:share_product_v2/widgets/CustomOnlyTextContainer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/widgets/bottomBar.dart';

class LoginMyPage extends StatefulWidget {
  @override
  _LoginMyPageState createState() => _LoginMyPageState();
}

class _LoginMyPageState extends State<LoginMyPage> {
  @override
  void initState() {
    super.initState();
    // Provider.of<UserProvider>(context, listen: false).getMyInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (_, _getMyinfo, __) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 33),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyInfoContainer(
                          username: _getMyinfo.username != null
                              ? "${_getMyinfo.username}"
                              : "",
                          phone: "${_getMyinfo.phNum}"),
                      // CustomLinkTextContainer(
                      //   title: "나의 대여상품",
                      //   link: '/user/product',
                      // ),
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
                        link: '/main',
                      ),
                      CustomLinkTextContainer(
                        title: "약관 및 정책",
                        link: '/policy',
                      ),
                      Container(
                        width: double.infinity,
                        height: 52,
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
                        onTap: () => _getMyinfo.logout(),
                        child: CustomOnlyTextContainer(title: "로그아웃"),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Color(0xffFAFAFA),
                height: 120,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 52,
                      child: Row(
                        children: [
                          Text("알림설정", style: normal_16_000),
                          Spacer(),
                          Switch(
                            value: _getMyinfo.userPush,
                            onChanged: (bool value) {
                              _getMyinfo.changePush();
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
                          fontSize: 10.sp,
                          color: Color(0xff999999),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   child: BottomBar(),
              // ),
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

  MyInfoContainer({this.username, this.phone});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: MyInfo(),
            type: PageTransitionType.rightToLeft,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        height: 70,
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
                            "http://192.168.100.232:5066/assets/images/user/${_getMyinfo.userProfileImg}",
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
                  Text(
                    this.username,
                    style: bold_16_000,
                  ),
                  Text(
                    this.phone,
                    style: normal_10_999,
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
