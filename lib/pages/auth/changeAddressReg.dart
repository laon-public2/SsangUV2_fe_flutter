import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  TextEditingController _addressDetail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30.0,
          ),
          onPressed: () => Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute),
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
                      await _myInfo.changeAddress(
                        this.widget.address,
                        "${this.widget.addressDetail} ${this._addressDetail.text}",
                        this.widget.la,
                        this.widget.lo,
                      );
                      await Provider.of<ProductProvider>(context, listen: false)
                          .changeUserPosition(
                        Provider.of<UserProvider>(context, listen: false).userLocationY,
                        Provider.of<UserProvider>(context, listen: false).userLocationX,
                      );
                      await Provider.of<ProductProvider>(context, listen: false).getGeolocator();
                      Navigator.pop(context);
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
}
