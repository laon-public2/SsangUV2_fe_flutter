import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/mypage/MySsangU.dart';
import 'package:share_product_v2/pages/product/ProductModified.dart';
import 'package:share_product_v2/pages/product/detailMapPage.dart';
import 'package:share_product_v2/pages/product/productApplyPrivatePage.dart';
import 'package:share_product_v2/providers/productController.dart';
import 'package:share_product_v2/providers/userController.dart';
import 'package:share_product_v2/widgets/bannerProduct.dart';
import 'package:share_product_v2/widgets/customdialogApplyReg.dart';
import 'package:share_product_v2/widgets/loading.dart';
import 'package:share_product_v2/widgets/loading2.dart';
import 'package:share_product_v2/widgets/simpleMap.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ImageView.dart';
import "dart:io";

class ProductDetailWant extends StatefulWidget {
  final int productIdx;
  final String category;

  const ProductDetailWant(this.productIdx, this.category);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailWant> {

  ProductController productController = Get.find<ProductController>();

  late GoogleMapController mapController;
  final LatLng _center = const LatLng(37.61686408091954, 126.89315008364576);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  late List<String> address;
  int _reviewCount = 130;
  int _page = 0;

  String username = "";

  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await _loadLocator();
    // });
  }

  Future<bool> _loadLocator() async {
    await productController.getproductDetail(this.widget.productIdx);
    print(productController.productDetail!.name);
    await productController.getProductReviewFive(this.widget.productIdx, _page);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadLocator(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분
        if (snapshot.hasData == false) {
          return Container(
            color: Colors.white,
            height: 300.h,
            child: Center(
                child: Loading2(),
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
          return _scaffold();
        }
      },
    );
  }

  _scaffold() {
    return Scaffold(
        body: SingleChildScrollView(
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: Platform.isIOS ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
            child: _body(),
          ),
        ),
        floatingActionButton: GetBuilder<UserController>(
          builder: (_myUser) {
                return _myUser.isLoggenIn.value
                    ? _myUser.username.value == productController.productDetail!.name
                        ? Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await productController.delProduct(
                                        productController.productDetail!.idx,
                                        _myUser.accessToken.value);
                                    await productController.getMainWant(0);
                                    await productController.getMainWant(0);
                                    _showDialogSuccess("삭제가 완료되었습니다.");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                    ),
                                    child: Container(
                                      // width:
                                      //     MediaQuery.of(context).size.width * 0.4,
                                      width: 150.w,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[500],
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(4, 4),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                            color:
                                                Colors.black.withOpacity(0.08),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          '요청종료',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GetBuilder<ProductController>(
                                  builder: (_product) {
                                    return InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductModified(
                                                        originalInfo: _product
                                                            .productDetail,
                                                        categoryString: this
                                                            .widget
                                                            .category,
                                                      )),
                                            );
                                          },
                                          child: Container(
                                            //미디어쿼리는 키보드가 올라오면 전체 화면을 재정의 하기때문에 api가 무한 호출되거나 키보드가 올라갔다 내려갔다가 한다. 이건 플러터의 버그임.
                                            //결론 쓰지 마셈. 왠만하면...
                                            // width:
                                            //     MediaQuery.of(context).size.width * 0.4,
                                            width: 130.w,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Color(0xffff0066),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: Offset(4, 4),
                                                  blurRadius: 4,
                                                  spreadRadius: 1,
                                                  color: Colors.black
                                                      .withOpacity(0.08),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                '수정',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductApplyPrivatePage(
                                    productController.productDetail!.idx,
                                    _myUser.userIdx.value,
                                    _myUser.userNum.value,
                                    productController.productDetail!.category_idx!,
                                    productController.productDetail!.title,
                                    productController.productDetail!.min_price,
                                    productController.productDetail!.max_price,
                                    productController.productDetail!.start_date,
                                    productController.productDetail!.end_date,
                                    "${productController.productDetail!.address}",
                                    "${productController.productDetail!.address_detail}",
                                    productController.productDetail!.location.y,
                                    productController.productDetail!.location.x,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _myUser.isLoggenIn.value
                                      ? Color(0xffff0066)
                                      : Colors.grey[300],
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
                                    '대여등록하기',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                    : InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: _myUser.isLoggenIn.value
                                  ? Color(0xffff0066)
                                  : Colors.grey[300],
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
                                '대여등록하기',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
              },

        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
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
                    //배너 사이즈 및 색
                    Positioned.fill(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageView(
                                      productController.productDetail!.image)));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey[300],
                          child: productController.productDetail != null
                              ? BannerItemProduct(
                                  false,
                                  productController.productDetail!.image,
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
                        '${_dateFormat(productController.productDetail!.start_date)}~${_dateFormat(productController.productDetail!.end_date)}',
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
              GetBuilder<UserController>(
                builder: (_user){
                  return Container(
                    child: Column(
                      children: [
                        //타이틀 부분
                        Container(
                          width: double.infinity,
                          height: 130.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffdddddd),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 10),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          "${(productController.productDetail!.distance)!.toStringAsFixed(2)}km",
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
                                      '${productController.productDetail!.title}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '${productController.productDetail!.name}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff999999),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 10),
                                // alignment: Alignment.topLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${productController.productDetail!.min_price} ~ ${productController.productDetail!.max_price}원',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    _user.username ==
                                            productController.productDetail!.name
                                        ? InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MySSangU(productController
                                                              .productDetail!
                                                              .idx)));
                                            },
                                            child: Container(
                                              width: 170.w,
                                              height: 30.h,
                                              decoration: BoxDecoration(
                                                color: Color(0xffff0066),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '대여 등록글 전체리스트 보기',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //사이즈 박스 사이공간 조절
                        SizedBox(height: 10.h),
                        //설명 부분
                        Container(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 10),
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
                            '${productController.productDetail!.description}',
                          ),
                        ),
                        //사이즈 박스 사이공간 조절
                        SizedBox(height: 10),
                        //주소 및 지도 표시 부분
                        Container(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 10),
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
                                '${productController.productDetail!.address} ${productController.productDetail!.address_detail}',
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
                                        latitude: productController.productDetail!.location.y.toDouble(),
                                        longitude: productController.productDetail!.location.x.toDouble(),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) {
                                          return DetailMapPage(
                                            address:
                                                "${productController.productDetail!.address} ${productController.productDetail!.address_detail}",
                                            latitude:
                                                productController.productDetail!.location.y.toDouble(),
                                            longitude:
                                                productController.productDetail!.location.x.toDouble(),
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
                        SizedBox(height: 60),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
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

  void _showDialogSuccess(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApplyReg(Center(child: Text(text)), '확인');
        });
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
