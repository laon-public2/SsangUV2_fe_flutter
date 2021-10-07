import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/auth/SuccessReg.dart';
import 'package:share_product_v2/providers/fcm_model.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/regUserProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/widgets/customdialogApplyReg.dart';
import 'package:share_product_v2/widgets/loading.dart';

import 'choiceUser.dart';

class ChangeAddressReg extends StatefulWidget {
  final num la;
  final num lo;
  final String address;
  final String addressDetail;

  ChangeAddressReg(this.la, this.lo, this.address, this.addressDetail);

  @override
  _ChangeAddressState createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddressReg> {
  ProductController productController = Get.find<ProductController>();
  TextEditingController _addressDetail = TextEditingController();
  bool? regAddressEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30.0,
          ),
          onPressed: () => Navigator.popUntil(
              context, (Route<dynamic> route) => route is PageRoute),
        ),
      ),
      body: _body(),
    );
  }

  _body() {
    return Consumer<UserProvider>(
      builder: (_, _myInfo, __) {
        return Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 10.0, bottom: 20),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      '상세 주소를\n입력해주세요.',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      "${this.widget.address} ${this.widget.addressDetail}",
                      style: TextStyle(
                        color: Color(0xff999999),
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                TextField(
                  enabled: regAddressEnabled,
                  controller: _addressDetail,
                  decoration: InputDecoration(
                    labelText: "자세한 주소 입력",
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    color: Color(0xff999999),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () async {
                    if (_addressDetail.text == "") {
                      return;
                    } else {
                      _showDialogLoading();
                      regAddressEnabled = false;
                      await Provider.of<RegUserProvider>(context, listen: false).regUserForm(
                        pwd.text,
                        name.text,
                        userType,
                        '1',
                        comNum.text,
                        regimage == null ? File('') : regimage!,
                        Provider.of<FCMModel>(context, listen: false).mbToken!,
                      );
                      await Provider.of<UserProvider>(context, listen: false)
                          .getAccessTokenReg(
                        Provider.of<RegUserProvider>(context, listen: false).phNum!,
                        pwd.text,
                      );
                      if (Provider.of<RegUserProvider>(context, listen: false)
                          .regUserTruth) {
                        await _myInfo.changeAddress(
                          this.widget.address,
                          "${this.widget.addressDetail} ${this._addressDetail.text}",
                          this.widget.la,
                          this.widget.lo,
                        );
                        productController.changeUserPosition(Provider.of<UserProvider>(context, listen: false).userLocationLatitude,
                          Provider.of<UserProvider>(context, listen: false).userLocationLongitude);
                        // await Provider.of<ProductController>(context, listen: false).changeUserPosition(
                        //
                        // );
                        await productController.getGeolocator();
                        await Provider.of<UserProvider>(context, listen: false).getMyInfo();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SuccessReg()),
                        );
                      } else {
                        _showDialogSuccess('해당 전화번호는 이미 존재하는 회원입니다.');
                      }

                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: _addressDetail.text != ""
                          ? Color(0xffff0066)
                          : Color(0xff999999),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "완료",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  void _showDialogLoading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Loading();
        });
  }

  void _showDialogSuccess(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApplyReg(Center(child: Text(text)), '확인');
        });
  }
}
