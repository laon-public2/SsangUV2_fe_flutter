import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialogApplyReg extends StatelessWidget {
  final Widget child;
  final String acceptText;

  CustomDialogApplyReg(this.child, this.acceptText);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: WillPopScope(
        onWillPop: () => _willPopCallback(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.2),
          child: Center(
            child: Container(
              width: 320.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  EdgeInsets.only(top: 20.h, left: 10.h, right: 10.h, bottom: 10.h),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                child,
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.h,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: Color(0xffff0066),
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          child: Text(
                            acceptText,
                            style: TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
  Future<bool> _willPopCallback() async {
    return true;
  }
}
