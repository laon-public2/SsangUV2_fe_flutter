import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/chat/CustomerMessage.dart';
import 'package:share_product_v2/pages/product/ImageView.dart';
import 'package:share_product_v2/pages/product/detailMapPage.dart';
import 'package:share_product_v2/pages/product/writeReview.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/bannerProduct.dart';
import 'package:share_product_v2/widgets/loading.dart';
import 'package:share_product_v2/widgets/reviewPage.dart';
import 'package:share_product_v2/widgets/simpleMap.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailRent extends StatefulWidget {
  final int productIdx;
  final String category;
  const ProductDetailRent(this.productIdx, this.category);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailRent> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(37.61686408091954, 126.89315008364576);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  List<String> address;
  List<String> Pics;
  int _page = 0;

  void initState() {
    super.initState();
  }

  Future<bool> _loadLocator() async {
    print("주소 ===== $address");
    await Provider.of<ProductProvider>(context, listen: false)
        .getproductDetail(this.widget.productIdx);
    await Provider.of<ProductProvider>(context, listen: false)
        .getProductReviewFive(this.widget.productIdx, _page);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: _loadLocator(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분
                  if (snapshot.hasData == false) {
                    return Container(
                      height: 300.h,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xffff0066)),
                        ),
                      ),
                    );
                  }
                  //error가 발생하게 될 경우 반환하게 되는 부분
                  else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  } else {
                    return _body();
                  }
                })),
        floatingActionButton: Consumer<ProductProvider>(
          builder: (_, _product, __){
            return InkWell(
              onTap: () async{
                String uuid = await Provider.of<ProductProvider>(context, listen: false).rentInit(
                  Provider.of<UserProvider>(context, listen: false).userIdx,
                  _product.productDetail.receiverIdx,
                  this.widget.productIdx,
                  Provider.of<UserProvider>(context, listen: false).accessToken,
                );
                print(uuid);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerMessage(
                      uuid,
                      this.widget.productIdx,
                      _product.productDetail.title,
                      this.widget.category,
                      _product.productDetail.name,
                      _product.productDetail.price,
                      _product.productDetail.productFiles[0].path,
                  ))
                );
              },
              child: Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Consumer<UserProvider>(
                  builder: (_, _user, __){
                    return Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _user.isLoggenIn ? Color(0xffff0066) : Colors.grey[400],
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
                          '대여문의하기',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
  _body() {
    return Consumer<ProductProvider>(
      builder: (__, _myProduct, _) {
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
                    //배너 사이즈 및 색
                    Positioned.fill(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageView(
                                    _myProduct.productDetail.productFiles
                                )
                              ));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey[300],
                          child: _myProduct.productDetail != null
                              ? BannerItemProduct(
                                  false,
                                  _myProduct.productDetail.productFiles,
                                )
                              : SizedBox(),
                        ),
                      ),
                    ),

                    //배너 그림자
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: double.infinity,
                          height: 80.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black,
                              ],
                              stops: [
                                0.0,
                                1.9,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: double.infinity,
                          height: 80.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black,
                                Colors.transparent,
                              ],
                              stops: [
                                0.0,
                                1.9,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    //날짜
                    Positioned(
                      left: 10,
                      right: 0,
                      bottom: 10,
                      child: Text(
                        '${_dateFormat(_myProduct.productDetail.startDate)}~${_dateFormat(_myProduct.productDetail.endDate)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    //뒤로가기
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 30,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        padding: const EdgeInsets.only(left: 0, right: 16),
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: Transform.rotate(
                              angle: 180 * pi / 180,
                              child: Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Colors.white,
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
                child: Column(
                  children: [
                    //타이틀 부분
                    Container(
                      width: double.infinity,
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xffdddddd),
                          ),
                        ),
                      ),
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 10),
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
                                      "${this.widget.category}",
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
                                      "${(_myProduct.productDetail.distance).toStringAsFixed(2)}km",
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
                              child: Column(
                                children: [
                                  Text(
                                    '${_myProduct.productDetail.title}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${_myProduct.productDetail.name}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff999999),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${_myProduct.productDetail.price}원',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //사이즈 박스 사이공간 조절
                    SizedBox(height: 10.h),
                    //설명 부분
                    Container(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 10),
                      width: double.infinity,
                      height: 124.h,
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
                        '${_myProduct.productDetail.description}',
                      ),
                    ),
                    //사이즈 박스 사이공간 조절
                    SizedBox(height: 10),
                    //주소 및 지도 표시 부분
                    Container(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 10),
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
                            '${_myProduct.productDetail.address} ${_myProduct.productDetail.addressDetail}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            child: Stack(
                              children: [
                                Container(
                                  height: 200,
                                  child: SimpleGoogleMaps(
                                    latitude: _myProduct.productDetail.lati,
                                    longitude: _myProduct.productDetail.longti,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (_) {
                                      return DetailMapPage(
                                        address:
                                            "${_myProduct.productDetail.address} ${_myProduct.productDetail.addressDetail}",
                                        latitude: _myProduct.productDetail.lati,
                                        longitude:
                                            _myProduct.productDetail.longti,
                                      );
                                    }));
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
                    //사이즈 박스 사이공간 조절
                    SizedBox(height: 10),
                    //리뷰 작성 부분
                    Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 20),
                      width: double.infinity,
                      // height: 300,
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
                        mainAxisSize: MainAxisSize.min,
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
                                    "${_myProduct.reviewPaging.totalCount}개",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffff0066),
                                      fontSize: 16.sp,
                                    ),
                                  )
                                ],
                              ),
                              _myProduct.productDetail.review != null ?
                              _myProduct.productDetail.review
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => WriteReview(
                                                  this.widget.productIdx)),
                                        );
                                      },
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
                                      ),
                                    )
                                  : SizedBox()
                                  : SizedBox(),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //별 갯수
                              RatingBarIndicator(
                                itemSize: 20,
                                rating: _myProduct.reviewPaging.averageRating ==
                                        null
                                    ? 0
                                    : _myProduct.reviewPaging.averageRating
                                        .toDouble(),
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 0.5),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Color(0xffff0066),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              SizedBox(
                                width: 60.w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "${_myProduct.reviewPaging.averageRating == null ? 0.0 : _myProduct.reviewPaging.averageRating}",
                                      style: TextStyle(
                                        color: Color(0xffff0066),
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Text(
                                      "|",
                                      style: TextStyle(
                                        color: Color(0xffdddddd),
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    Text(
                                      "5.0",
                                      style: TextStyle(
                                        color: Color(0xff999999),
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Flexible(
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, idx) {
                                return reviewPage(
                                  picture:
                                      "${_myProduct.productReviewnot[idx].productFiles}",
                                  nickname:
                                      "${_myProduct.productReviewnot[idx].nickname}",
                                  createAt:
                                      "${_reviewdateFormat(_myProduct.productReviewnot[idx].createAt)}",
                                  grage: _myProduct.productReviewnot[idx].grade,
                                  description:
                                      "${_myProduct.productReviewnot[idx].description}",
                                );
                              },
                              separatorBuilder: (context, idx) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0),
                                  child: Divider(),
                                );
                              },
                              itemCount: _myProduct.reviewPaging.totalCount < 5
                                  ? _myProduct.productReviewnot.length
                                  : 5,
                            ),
                          ),
                          _myProduct.productReviewnot.length != 0
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('더보기',
                                        style: TextStyle(
                                          color: Color(0xffff0066),
                                          fontSize: 14.sp,
                                        ))
                                  ],
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  _category(int categoryNum) {
    if (categoryNum == 2) {
      String value = '생활용품';
      return value;
    } else if (categoryNum == 3) {
      String value = '스포츠/레저';
      return value;
    } else if (categoryNum == 4) {
      String value = '육아';
      return value;
    } else if (categoryNum == 5) {
      String value = '반려동물';
      return value;
    } else if (categoryNum == 6) {
      String value = '가전제품';
      return value;
    } else if (categoryNum == 7) {
      String value = '의류/잡화';
      return value;
    } else if (categoryNum == 8) {
      String value = '가구/인테리어';
      return value;
    } else if (categoryNum == 9) {
      String value = '자동차용품';
      return value;
    } else if (categoryNum == 10) {
      String value = '기타';
      return value;
    } else {
      String value = '여행';
      return value;
    }
  }

  _dateFormat(String date) {
    String formatDate(DateTime date) => new DateFormat("MM/dd").format(date);
    return formatDate(DateTime.parse(date));
  }

  _reviewdateFormat(String date) {
    String formatDate(DateTime date) => new DateFormat("yy.MM.dd").format(date);
    return formatDate(DateTime.parse(date));
  }

  _showLoading() {
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.0),
        builder: (BuildContext context) {
          return Loading();
        });
  }
}
