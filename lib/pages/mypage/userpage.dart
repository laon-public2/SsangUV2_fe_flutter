import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/utils/StringUtil.dart';
import 'package:share_product_v2/widgets/customAppBar%20copy.dart';
import 'package:share_product_v2/widgets/customdialog.dart';

class UserPage extends StatelessWidget {
  UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBarWithPrev("내 정보", 1.0, context),
      body: Consumer<UserProvider>(
        builder: (_, user, __) {
          print(user.loginMember.member.kakao.profile);
          userProvider = user;
          if (!userProvider.isLoggenIn) {
            Navigator.of(context).pop();
          }
          return body(context);
        },
      ),
    );
  }

  Widget body(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          usernameItem(nullReturnEmpty(userProvider.loginMember.member.name)),
          emailItem(nullReturnEmpty(userProvider.loginMember.member.username)),
          // phoneItem(nullReturnEmpty(null)),
          // dealItem(context, 12, 3),
          Spacer(),
          InkWell(
            onTap: () {
              _showDialog(context);
              // Navigator.of(context).pushNamed("/withdraw");
            },
            child: Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  "회원탈퇴",
                  style: TextStyle(fontSize: 14.h, color: Color(0xff999999)),
                )),
          )
        ],
      ),
    );
  }

  void _showDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(dialogChild(), "확인", () {
            userProvider.withdrawal().then((value) {
              Navigator.of(context).pushNamed("/withdraw");
            });
          });
        });
  }

  Widget dialogChild() {
    return Column(
      children: [
        Text(
          "탈퇴시 모든 정보가 사라집니다.",
          style: TextStyle(fontSize: 14.sp, color: Color(0xff333333)),
        ),
        SizedBox(
          height: 12.h,
        ),
        Text(
          "탈퇴하시겠습니까?",
          style: TextStyle(fontSize: 14.sp, color: Color(0xff999999)),
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }

  Widget usernameItem(String username) {
    return SizedBox(
        width: double.infinity,
        height: 40.h,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(username,
                style: TextStyle(
                    fontSize: 18.h,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff333333)))));
  }

  Widget emailItem(String email) {
    return SizedBox(
        width: double.infinity,
        height: 58.h,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(email,
                    style: TextStyle(
                        fontSize: 18.h,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff333333))),
                SizedBox(
                  height: 4,
                ),
                // Row(
                //   children: [
                //     Text("대여등급",
                //         style: TextStyle(
                //             fontSize: 12.h, color: Color(0xff444444))),
                //     SizedBox(
                //       width: 8,
                //     ),
                //     Text("대여등급",
                //         style: TextStyle(
                //             fontSize: 12.h, color: Color(0xff444444))),
                //   ],
                // )
              ],
            )));
  }

  Widget phoneItem(String phoneNumber) {
    var isSetPhoneNumber = false;
    return SizedBox(
        width: double.infinity,
        height: 44.h,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: isSetPhoneNumber
                ? Text(phoneNumber,
                    style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff333333)))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("연락처를 등록해주세요.",
                          style: TextStyle(
                              fontSize: 16.h, color: Color(0xff999999))),
                      InkWell(
                        onTap: () {
                          print("나이스 아이디 연동");
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: Row(
                            children: [
                              Text("등록하기",
                                  style: TextStyle(
                                      fontSize: 14.h,
                                      color: Color(0xff333333))),
                              Icon(Icons.keyboard_arrow_right)
                            ],
                          ),
                        ),
                      )
                    ],
                  )));
  }

  // Widget dealItem(context, int rentNum, int borrowNum) {
  //   return SizedBox(
  //       width: double.infinity,
  //       height: 143.h,
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 20),
  //         child: Column(
  //           children: [
  //             SizedBox(
  //                 height: 55.h,
  //                 child: Row(
  //                   children: [
  //                     Text("거래현황",
  //                         style: TextStyle(
  //                             fontSize: 18.h,
  //                             fontWeight: FontWeight.w500,
  //                             color: Color(0xff333333))),
  //                     SizedBox(
  //                       width: 12,
  //                     ),
  //                     Icon(Icons.list)
  //                   ],
  //                 )),
  //             SizedBox(
  //               height: 44.h,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text("빌린 건수",
  //                       style: TextStyle(
  //                           fontSize: 16.h, color: Color(0xff333333))),
  //                   Text("${userProvider.loginMember.borrowCount} 건",
  //                       style: TextStyle(
  //                           fontSize: 16.h,
  //                           color: Theme.of(context).primaryColor)),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(
  //               height: 44.h,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text("빌려준 건수",
  //                       style: TextStyle(
  //                           fontSize: 16.h, color: Color(0xff333333))),
  //                   Text("${userProvider.loginMember.purchaseCount} 건",
  //                       style: TextStyle(
  //                           fontSize: 16.h,
  //                           color: Theme.of(context).primaryColor)),
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //       )
  //     );
  // }
}
