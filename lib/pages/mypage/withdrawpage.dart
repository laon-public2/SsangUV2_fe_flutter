import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/widgets/customAppBar%20copy.dart';

class WithdrawPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWithPrev(appBar: AppBar(), title: "회원탈퇴", elevation: 1.0,),
      body: SafeArea(child: body(context)),
    );
  }

  Widget body(context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Spacer(),
          Text(
            "회원탈퇴가 완료되었습니다.\n30일간의 유예기간이 발생되며\n30일후 모든 정보가 삭제됩니다.",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xff333333)),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: SizedBox(
              height: 40.h,
              width: double.infinity,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(
                  "확인",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
