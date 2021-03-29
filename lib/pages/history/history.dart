import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/pages/history/chatting.dart';
import 'package:share_product_v2/pages/history/share.dart';
import 'package:share_product_v2/pages/history/shared.dart';

class History extends StatefulWidget {
  const History({Key key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1.0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          "이용 내역",
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
        ),
        centerTitle: true,
        bottom: TabBar(
          unselectedLabelColor: Color(0xff999999),
          labelColor: Color(0xff333333),
          indicator: UnderlineTabIndicator(
            borderSide:
                BorderSide(width: 3.0, color: Theme.of(context).primaryColor),
            insets: EdgeInsets.symmetric(horizontal: 30.w),
          ),
          controller: controller,
          tabs: [
            Tab(
              text: "채팅 내역",
            ),
            Tab(
              text: "대여 내역",
            ),
          ],
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return TabBarView(
      controller: controller,
      children: [
        Chatting(),
        Share(),
      ],
    );
  }
}
