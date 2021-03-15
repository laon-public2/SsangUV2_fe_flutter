import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/widgets/circleButton.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDialog extends StatelessWidget {
  final String nickname;
  final String phoneNumber;

  ContactDialog(this.nickname, this.phoneNumber);

  Future<void> _goToContact(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 320.h,
        padding:
            EdgeInsets.only(top: 20.h, left: 10.h, right: 10.h, bottom: 10.h),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text("$nickname님에게",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff333333))),
          SizedBox(
            height: 12.h,
          ),
          Text(
            "연결하실 방법을 선택해주세요.",
            style: TextStyle(fontSize: 14.sp, color: Color(0xff333333)),
          ),
          SizedBox(
            height: 28.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleButton(
                  Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  () => _goToContact("tel:$phoneNumber")),
              CircleButton(
                  Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                  () => _goToContact("sms:$phoneNumber")),
            ],
          ),
          SizedBox(
            height: 28.h,
          ),
          SizedBox(
            height: 32.h,
            width: double.infinity,
            child: RaisedButton(
              color: Color(0xfff1f1f1),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "취소",
                style: TextStyle(color: Color(0xff333333), fontSize: 16.sp),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
