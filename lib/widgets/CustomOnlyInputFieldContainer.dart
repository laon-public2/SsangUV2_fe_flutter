import 'package:flutter/material.dart';
import 'package:share_product_v2/consts/textStyle.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";

class CustomTextFieldContainer extends StatelessWidget {
  final String title;
  TextEditingController controller;
  CustomTextFieldContainer({this.title, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xffdddddd),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: 55.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextField(
              controller: controller,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xffaaaaaa),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: '$title',
                hintStyle: TextStyle(fontSize: 14, color: Color(0xffaaaaaa)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
