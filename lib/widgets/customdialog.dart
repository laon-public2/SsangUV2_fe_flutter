import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialog extends StatelessWidget {

  final Widget child;
  final String acceptText;
  final Function() accept;

  CustomDialog(this.child, this.acceptText, this.accept);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 320.h,
        padding:
        EdgeInsets.only(top: 20.h, left: 10.h, right: 10.h, bottom: 10.h),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          child,
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 32.h,
                  child: RaisedButton(
                    color: Color(0xfff1f1f1),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("취소",
                        style: TextStyle(
                            color: Color(0xff333333), fontSize: 16.sp)),
                  ),
                ),
              ),
              SizedBox(
                width: 10.h,
              ),
              Expanded(
                child: SizedBox(
                  height: 32.h,
                  child: RaisedButton(
                    color: Color(0xffff0066),
                    onPressed: () => accept(),
                    child: Text(
                      acceptText,
                      style:
                      TextStyle(color: Colors.white, fontSize: 16.sp),
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

