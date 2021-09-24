import 'package:flutter/material.dart';
import 'package:share_product_v2/widgets/customText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomPopup extends StatefulWidget {
  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 0,
        height: 346,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              child: Image.asset(
                "assets/popup_img.png",
                width: 114,
                height: 110,
              ),
              right: -12,
              bottom: 30.h,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 101, bottom: 36),
                  child: SizedBox(
                    width: 141,
                    height: 78,
                    child: Image.asset("assets/popup_text.png"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    color: Color(0xff383D63),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: InkWell(
                    onTap: () => _launchURL(),
                    child: CustomText(
                      text: "문의 : support@raons.kr",
                      fontSize: 12.sp,
                      textColor: Colors.white,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: -1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isCheck = !isCheck;
                            });
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 20,
                                  height: 20.h,
                                  child: Checkbox(
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: isCheck,
                                      onChanged: (value) => setState(() {
                                            isCheck = value!;
                                          }))),
                              SizedBox(
                                width: 10,
                              ),
                              CustomText(
                                text: "1일 동안 보지 않기",
                                fontSize: 12.sp,
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.remove("timestamp");

                          if (isCheck) {
                            int currentTimeStamp =
                                DateTime.now().millisecondsSinceEpoch;
                            pref.setInt("timestamp", currentTimeStamp);
                          }

                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
                          height: 20.h,
                          child: Center(
                            child: CustomText(
                              fontSize: 12.sp,
                              textColor: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              text: "닫기",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'mailto:support@raons.kr';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
