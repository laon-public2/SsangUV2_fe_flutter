import 'package:flutter/material.dart';
import 'package:share_product_v2/consts/textStyle.dart';
import 'package:share_product_v2/pages/auth/choiceUser.dart';
import 'package:share_product_v2/pages/auth/usePhone.dart';
import 'package:share_product_v2/pages/mypage/loginpage_use_phone.dart';
import 'package:share_product_v2/pages/test.dart';
import 'package:share_product_v2/widgets/CustomButton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/widgets/CustomLinkTextContainer.dart';
import 'package:share_product_v2/widgets/CustomOnlyTextContainer.dart';
import 'package:share_product_v2/widgets/bottomBar.dart';

import '../notLoginPage.dart';

class NoLoginMyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 44),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "로그인이 필요합니다",
                    style: bold_16_000,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0, bottom: 25),
                    child: Text(
                      "회원가입하시고 공유경제의 첫걸음을 떼어보세요.",
                      style: normal_10_999,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: CustomButton(
                      title: "로그인/회원가입",
                      enable: true,
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UsePhone(),
                          ),
                        );
                      },
                    ),
                  ),
                  // Padding(
                  //     padding: const EdgeInsets.only(
                  //       top: 20.0,
                  //     ),
                  //     child: CustomOnlyTextContainer(title: "알림내역")),
                  SizedBox(height: 10.h),
                  CustomLinkTextContainer(
                    title: "고객센터",
                    link: '/center',
                  ),
                  Container(
                    width: double.infinity,
                    height: 52,
                    child: Row(
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
                ],
              ),
            ),
          ),
          // Container(
          //   color: Color(0xffFAFAFA),
          //   height: 120,
          //   padding: const EdgeInsets.only(left: 20, right: 20),
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Container(
          //         width: double.infinity,
          //         height: 52,
          //         child: Row(
          //           children: [
          //             Text("알림설정", style: normal_16_000),
          //             Spacer(),
          //             Switch(
          //               value: false,
          //               onChanged: (bool value) {},
          //             ),
          //           ],
          //         ),
          //       ),
          //       ConstrainedBox(
          //         constraints: BoxConstraints(maxWidth: 235.w),
          //         child: Text(
          //           "내용입니다.내용입니다.내용입니다.내용입니다.내용입니다.내용입니다.내용입니다.내용입니다.",
          //           style: normal_8_444,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   child: BottomBar(),
          // ),
        ],
      ),
    );
  }
}
