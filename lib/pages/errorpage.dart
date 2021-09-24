import 'package:flutter/material.dart';
import 'package:share_product_v2/utils/APIUtil.dart';
import 'package:share_product_v2/widgets/customDoneBtn.dart';
import 'package:share_product_v2/widgets/customText.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorPage extends StatelessWidget {
  final String message;

  ErrorPage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned(
                child: Image.asset(
                  "assets/loading1.gif",
                  width: 100.0,
                  height: 100.0,
                ),
                top: 100.h,
                left: 0,
                right: 0,
              ),
              Positioned.fill(
                left: 12,
                right: 12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "error page",
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CustomText(
                        text: message,
                        fontSize: 18,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                left: 12,
                right: 12,
                child: CustomDoneBtn(
                  text: "확인",
                  func: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "/main", (route) => route.isFirst);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
