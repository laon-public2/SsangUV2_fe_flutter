import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/widgets/BackBtn.dart';
import 'package:share_product_v2/widgets/customAppBar%20copy.dart';

class PolicyDetailPage extends StatelessWidget {
  String title;
  String content;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args = ModalRoute.of(context).settings.arguments;

    this.title = args["title"];
    this.content = args["content"];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBarWithPrev(args["title"], 0.0, context),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          content,
          style: TextStyle(
              fontSize: 14.h,
              fontWeight: FontWeight.normal,
              fontFamily: "NotoSans"),
        ),
      ),
    );
  }
}
