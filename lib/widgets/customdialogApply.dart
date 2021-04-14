import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialogApply extends StatelessWidget {
  final Widget child;
  final String acceptText;

  CustomDialogApply(this.child, this.acceptText);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320.h,
        padding: EdgeInsets.only(top: 20.h, left: 10.h, right: 10.h, bottom: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          child,
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40.h,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Color(0xffff0066),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      acceptText,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
