import 'package:flutter/material.dart';
import 'package:share_product_v2/widgets/customText.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar {
  static Widget appBar(String title, double elevation) {
    return AppBar(
      brightness: Brightness.light,
      title: CustomText(
        text: title,
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: elevation,
      backgroundColor: Colors.white,
    );
  }

  static Widget appBarWithPrev(
      String title, double elevation, BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      title: CustomText(
        text: title,
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        textColor: Colors.black,
      ),
      automaticallyImplyLeading: false,
      leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.black,
          )),
      centerTitle: true,
      elevation: elevation,
      backgroundColor: Colors.white,
    );
  }
}
