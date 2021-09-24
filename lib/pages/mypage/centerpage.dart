import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/widgets/customAppBar%20copy.dart';
import 'package:share_product_v2/widgets/customdialog.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class CenterPage extends StatelessWidget {
  final centerList = [
    {"title": "쌩유 카카오톡 문의", "type": "kakao"},
    // {"title": "쌩유 고객센터 전화 문의", "type": "phone"},
    {"title": "쌩유 배너광고, 제휴 문의", "type": "mail"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWithPrev(appBar: AppBar(), title: "고객센터", elevation: 1.0,),
      // appBar: AppBarWithPrev(appAppBar(), "고객센터", 1.0, context),
      body: body(context),
    );
  }

  Widget body(context) {
    return Column(
      children: centerList
          .map((e) => menuItem(context, e["title"]!, e["type"]!))
          .toList(),
    );
  }

  Widget menuItem(context, String title, String type) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 48.h,
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(color: Color(0xffeeeeee)),
      )),
      child: SizedBox(
        height: 48.h,
        child: InkWell(
          onTap: () {
            _showDialog(context, title, type);
          },
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.normal),
                  ),
                  Icon(Icons.keyboard_arrow_right)
                ],
              )),
        ),
      ),
    );
  }

  void _showDialog(context, String title, String type) {
    final urls = {
      "kakao": "https://open.kakao.com/o/sc14ylyc",
      "phone": "tel:01020664742",
      "mail": "mailto:mdjoo0810@gmail.com"
    };
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              dialogChild(title), "확인", () => _goToContact(urls[type]!));
        });
  }

  Future<void> _goToContact(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget dialogChild(String title) {
    return Column(
      children: [
        Text(
          "$title 으로",
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xff333333)),
        ),
        SizedBox(
          height: 12.h,
        ),
        Text(
          "이동하시겠습니까?",
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xff333333)),
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
}
