import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget CircleButton(Icon icon,Function action) {
  return ClipOval(
    child: Material(
      color: Color(0xffFF0066), // button color
      child: InkWell(
        splashColor: Color(0xffDFB714), // inkwell color
        child: SizedBox(
            width: 52.h,
            height: 52.h,
            child: Padding(
              padding: EdgeInsets.all(12.h),
              child: icon,
              // child: Image.asset(
              //   path,
              //   width: 24,
              //   height: 24,
              // ),
            )),
        onTap: () {
          action();
        },
      ),
    ),
  );
}