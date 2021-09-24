import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_product_v2/pages/product/detailMapPage.dart';
import 'package:share_product_v2/widgets/simpleMap.dart';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProductDetail extends StatefulWidget {
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(37.61686408091954, 126.89315008364576);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  late List<String> address;
  int _reviewCount = 130;

  void initState(){
    super.initState();
    _loadLocator();

  }

  _loadLocator() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? addressStr = pref.get("address") as String?;
    setState(() {
      this.address = addressStr!.split(",");
    });
    print("현재 상품 주소 ==== ${this.address}");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _body(),
      ),
    );
  }

  _body() {
    return Container(
      // height: 970,
      color: Color(0xffebebeb),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffdddddd),
                ),
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 30,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Transform.rotate(
                          angle: 180 * pi / 180,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 30.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffdddddd),
                ),
              ),
            ),
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 70,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffff0066),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "가구/인테리어",
                            style: TextStyle(
                                color: Color(0xffff0066),
                                fontSize: 10,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            "0.2km",
                            style: TextStyle(
                              color: Color(0xff888888),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    '(빠른 대여요청)급매물 원합니다. 꼭이요...',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            width: double.infinity,
            height: 124,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0xffdddddd),
                ),
                bottom: BorderSide(
                  color: Color(0xffdddddd),
                ),
              ),
            ),
            child: Text(
              '완벽하게 넓다란 사무실입니다. 빌려주십쇼',
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0xffdddddd),
                ),
                bottom: BorderSide(
                  color: Color(0xffdddddd),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '가산디지털 1로 24...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        child: SimpleGoogleMaps(
                          latitude: double.parse(this.address[0]),
                          longitude: double.parse(this.address[1]),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return DetailMapPage(
                              address: "경기도 고양시 덕양구 삼송동",
                              latitude: double.parse(this.address[0]),
                              longitude: double.parse(this.address[1]),
                            );
                          }
                          )
                          );
                        },
                        child: Container(
                          height: 200,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0xffdddddd),
                ),
                bottom: BorderSide(
                  color: Color(0xffdddddd),
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '리뷰 ',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          "$_reviewCount개",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xffff0066),
                            fontSize: 16.sp,
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          Text(
                            '리뷰작성',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xffff0066),
                              fontSize: 16.sp,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xffff0066),
                            size: 16.sp,
                          )
                        ],
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xffff0066),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(4, 4),
                    blurRadius: 4,
                    spreadRadius: 1,
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '대여요청하기',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
