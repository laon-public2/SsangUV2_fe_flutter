import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/chat/CustomerMessage.dart';
import 'package:share_product_v2/pages/product/ImageView.dart';
import 'package:share_product_v2/pages/product/detailMapPage.dart';
import 'package:share_product_v2/pages/product/writeReview.dart';
import 'package:share_product_v2/providers/productController.dart';
import 'package:share_product_v2/providers/userController.dart';
import 'package:share_product_v2/widgets/bannerProduct.dart';
import 'package:share_product_v2/widgets/customdialogApplyReg.dart';
import 'package:share_product_v2/widgets/loading.dart';
import 'package:share_product_v2/widgets/loading2.dart';
import 'package:share_product_v2/widgets/reviewPage.dart';
import 'package:share_product_v2/widgets/simpleMap.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ProductModified.dart';
import "dart:io";

class ProductDetailRent extends StatefulWidget {
  final int productIdx;
  final String category;

  const ProductDetailRent(
      this.productIdx, this.category);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailRent> with TickerProviderStateMixin{


  ProductController productController = Get.find<ProductController>();
  UserController userController = Get.find<UserController>();
  
  //애니메이션 빌더
  late AnimationController _colorAni;
  late Animation _colorTween, _iconColorTween, _borderColorTween;

  bool _scrollListener(ScrollNotification scrollInfo){
    if(scrollInfo.metrics.axis == Axis.vertical) {
      _colorAni.animateTo(scrollInfo.metrics.pixels / 120);
      return true;
    }
    else {
      return false;
    }
  }

  late GoogleMapController mapController;
  final LatLng _center = const LatLng(37.61686408091954, 126.89315008364576);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  int _page = 0;

  void initState() {
    super.initState();
    _colorAni = AnimationController(duration: Duration(seconds: 0), vsync: this);
    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.white).animate(_colorAni);
    _iconColorTween = ColorTween(begin: Colors.white, end: Color(0xffff0066)).animate(_colorAni);
    _borderColorTween = ColorTween(begin: Colors.transparent, end: Color(0xffff0066)).animate(_colorAni);
  }

  Future<bool> _loadLocator() async {
    await productController.getproductDetail(this.widget.productIdx);
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
                    print('data fail');
                    return Container(
                      color: Colors.white,
                      height: 300.h,
                      child: Center(
                        // child: CircularProgressIndicator(
                        //   valueColor:
                        //       AlwaysStoppedAnimation<Color>(Color(0xffff0066)),
                        // ),
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
                });
  }

  _scaffold(){
    return Scaffold(
      backgroundColor: Color(0xffebebeb),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Stack(
          children: [
            Positioned.fill(
              child: _body(),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _colorAni,
                builder: (context, child) => Container(
                  width: double.infinity,
                  height: 75.h,
                  decoration: BoxDecoration(
                    color: _colorTween.value,
                    border: Border(
                      bottom: BorderSide(
                        width: 0,
                        color: _borderColorTween.value,
                      ),
                    )
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: 75.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _colorAni,
                      builder: (context, child) => IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_sharp,
                          color: _iconColorTween.value,
                          size: 30.0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
        floatingActionButton: GetBuilder<UserController>(
          builder: (_myUser) {
                return _myUser.isLoggenIn.value ?
                _myUser.username.value == productController.productDetail!.name
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
                            width: 130.w,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
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
                                '삭제',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Consumer<ProductController>(
                      //   builder: (_, productController, __){
                      InkWell(
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ProductModified(
                                      originalInfo: productController.productDetail,
                                      categoryString: this.widget.category,
                                    )),
                                  );
                                },
                                child: Container(
                                  //미디어쿼리는 키보드가 올라오면 전체 화면을 재정의 하기때문에 api가 무한 호출되거나 키보드가 올라갔다 내려갔다가 한다. 이건 플러터의 버그임.
                                  //결론 쓰지 마셈. 왠만하면...
                                  width: 130.w,
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
                                      '수정',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                )
                    : InkWell(
                  onTap: () async {
                    final uvm = userController;
                    if(uvm.isLoggenIn.value){
                      String uuid = await productController.rentInit(userController.userIdx.value,
                        productController.productDetail!.receiver_idx!,
                        this.widget.productIdx,
                        userController.accessToken.value,);
                      // await Provider.of<ProductController>(
                      //     context,
                      //     listen: false)
                      //     .rentInit(
                      //   userController.userIdx.value,
                      //   productController.productDetail!.receiver_idx!,
                      //   this.widget.productIdx,
                      //   userController.accessToken.value,
                      // );
                      print("에러체크");
                      print(uuid);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerMessage(
                                uuid,
                                this.widget.productIdx,
                                productController.productDetail!.title,
                                this.widget.category,
                                productController.productDetail!.name,
                                productController.productDetail!.price,
                                productController
                                    .productDetail!.image[0].file,
                                "INIT",
                                productController.productDetail!.receiver_idx!,
                                productController.productDetail!.fcm_token,
                                userController.userFBtoken.value,
                                userController.userIdx.value,
                              )));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: GetBuilder<UserController>(
                      builder: (_user){
                        return Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _user.isLoggenIn.value
                                ? Color(0xffff0066)
                                : Colors.grey[400],
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
                ):
                InkWell(
                  onTap: () async {
                    final uvm = userController;
                    if(uvm.isLoggenIn.value){
                      String uuid = await productController.rentInit(
                        userController.userIdx.value,
                        productController.productDetail!.receiver_idx!,
                        this.widget.productIdx,
                        userController.accessToken.value,);
                      // await Provider.of<ProductController>(
                      //     context,
                      //     listen: false)
                      //     .rentInit(
                      //   userController.userIdx.value,
                      //   productController.productDetail!.receiver_idx!,
                      //   this.widget.productIdx,
                      //   userController.accessToken.value,
                      // );
                      print("에러체크");
                      print(uuid);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerMessage(
                                uuid,
                                this.widget.productIdx,
                                productController.productDetail!.title,
                                this.widget.category,
                                productController.productDetail!.name,
                                productController.productDetail!.price,
                                productController
                                    .productDetail!.image[0].file,
                                "INIT",
                                productController.productDetail!.receiver_idx!,
                                productController.productDetail!.fcm_token,
                                userController.userFBtoken.value,
                                userController.userIdx.value,
                              )));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    child: GetBuilder<UserController>(
                      builder: (_user){
                        return Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _user.isLoggenIn.value
                                ? Color(0xffff0066)
                                : Colors.grey[400],
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
    return NotificationListener<ScrollNotification>(
          onNotification: _scrollListener,
          child: SingleChildScrollView(
            child: Container(
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
                                PageTransition(
                                  child: ImageView(productController.productDetail!.image),
                                  type: PageTransitionType.fade,
                                ),
                              );
                            },
                            child: Hero(
                              tag: "ProductDetailImageView",
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
                        // Positioned(
                        //   left: 0,
                        //   right: 0,
                        //   top: 30,
                        //   child: Container(
                        //     width: double.infinity,
                        //     height: 50,
                        //     padding: const EdgeInsets.only(left: 0, right: 16),
                        //     child: Container(
                        //       width: double.infinity,
                        //       height: 52,
                        //       alignment: Alignment.topLeft,
                        //       child: IconButton(
                        //         icon: Icon(
                        //           Icons.arrow_back_ios_sharp,
                        //           color: Colors.white,
                        //           size: 30.0,
                        //         ),
                        //         onPressed: () {
                        //           Navigator.pop(context);
                        //         },
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '${productController.productDetail!.price}원',
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
                          const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
                          width: double.infinity,
                          // height: 200.h,
                          constraints: BoxConstraints(
                            maxHeight: double.infinity,
                          ),
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
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(builder: (_) {
                                          return DetailMapPage(
                                            address:
                                            "${productController.productDetail!.address} ${productController.productDetail!.address_detail}",
                                            latitude: productController.productDetail!.location.y.toDouble(),
                                            longitude: productController.productDetail!.location.x.toDouble(),
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
                                        "${productController.reviewPaging.totalCount}개",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xffff0066),
                                          fontSize: 16.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                  productController.productDetail!.review_possible != null
                                      ? productController.productDetail!.review_possible!
                                      ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WriteReview(this
                                                    .widget
                                                    .productIdx)),
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
                                    rating: productController.reviewPaging.averageRating ==
                                        null
                                        ? 0
                                        : productController.reviewPaging.averageRating!
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
                                          "${productController.reviewPaging.averageRating == null ? 0.0 : productController.reviewPaging.averageRating}",
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
                                      "${productController.productReviewnot[idx]!.productFiles}",
                                      nickname:
                                      "${productController.productReviewnot[idx]!.nickname}",
                                      createAt:
                                      "${_reviewdateFormat(productController.productReviewnot[idx]!.createAt)}",
                                      grage: productController.productReviewnot[idx]!.grade,
                                      description:
                                      "${productController.productReviewnot[idx]!.content}",
                                    );
                                  },
                                  separatorBuilder: (context, idx) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 3.0),
                                      child: Divider(),
                                    );
                                  },
                                  itemCount: productController.reviewPaging.totalCount < 5
                                      ? productController.productReviewnot.length
                                      : 5,
                                ),
                              ),
                              productController.productReviewnot.length != 0
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
            ),
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

