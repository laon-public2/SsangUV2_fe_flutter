import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'customText.dart';


class CustomDoneBtn extends StatelessWidget {

  final String text;
  final Function() func;

  CustomDoneBtn({this.text, this.func});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      child: RaisedButton(
        onPressed: func,
        child: CustomText(text: text, fontSize: 16.sp,),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        ),
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
