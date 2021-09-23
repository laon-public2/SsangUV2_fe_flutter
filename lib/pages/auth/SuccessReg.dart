import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/utils/APIUtil.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';
import 'package:share_product_v2/widgets/customdialogApplyReg.dart';
import 'package:share_product_v2/widgets/loading.dart';

import '../mainpage.dart';

class SuccessReg extends StatefulWidget {
  @override
  _SuccessRegState createState() => _SuccessRegState();
}

class _SuccessRegState extends State<SuccessReg> {
  @override
  Widget build(BuildContext context) {
    MyStatefulWidgetState myStatefulWidgetState = MyStatefulWidgetState();
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 300.h,
                child: Center(
                  child: Text(
                    '회원가입을\n축하해요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () async {
                  _showDialogLoading();

                  await Provider.of<UserProvider>(context, listen: false).getMyInfo();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: Color(0xffff0066),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "회원가입 완료",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () => _showDialog("회원가입완료 버튼을 눌러주세요"),
    );
  }

 _showDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApply(Center(child: Text(text)), '확인');
        });
  }

  void _showDialogLoading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Loading();
        });
  }
}
