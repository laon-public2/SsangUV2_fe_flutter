import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@immutable
class CustomText extends StatelessWidget {
  Color textColor = Colors.black;
  double fontSize = 14.sp;
  FontWeight fontWeight = FontWeight.w500;

  final String text;

  CustomText({this.textColor, this.fontSize, this.fontWeight, this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: fontWeight),
      overflow: TextOverflow.ellipsis,
    );
  }
}
