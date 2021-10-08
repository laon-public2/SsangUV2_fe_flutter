import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/product/ProductDetailRent.dart';
import 'package:share_product_v2/providers/homeController.dart';
import 'package:share_product_v2/providers/mapController.dart';
import 'package:share_product_v2/providers/productController.dart';
import 'package:share_product_v2/widgets/CustomDropdown.dart';
import 'package:share_product_v2/widgets/CustomDropdownMain.dart';
import 'package:share_product_v2/widgets/WantItemMainPage.dart';
import 'package:share_product_v2/widgets/banner.dart';
import 'package:share_product_v2/widgets/categoryItem.dart';
import 'package:share_product_v2/widgets/lendItemMainPage.dart';

import '../main.dart';
import 'KakaoMap.dart';
import 'chat/CustomerMessage.dart';

class HomePage extends StatelessWidget {

  double? lati;
  double? longti;
  CarouselController buttonCarouselController = CarouselController();
  HomeController homeController = Get.put(HomeController());
  MapController mapController = Get.put(MapController());
  ProductController productController = Get.find<ProductController>();

  final List<String> itemKind = [
    "빌려주세요",
    "빌려드려요",
    "도와주세요"
  ];

  late List<String> myLocation;
  late List<String> address;


  // homeScrollerListener() async{
  //
  //   final pvm = productController;
  //   if(homeScroller.position.pixels == homeScroller.position.maxScrollExtent){
  //     print("스크롤이 가장 아래입니다.");
  //     if(this._currentItem == "빌려드려요"){
  //       if(pvm.paging.totalCount != pvm.mainProducts.length){
  //         this.page++;
  //         productController
  //             .getMainRent(this.page);
  //       }
  //     }else{
  //       if(pvm.paging.totalCount != pvm.mainProductsWant.length){
  //         this.page++;
  //         productController
  //             .getMainWant(this.page);
  //       }
  //     }
  //   }
  // }

  // @override
  // void initState() {
  //
  // }

  // void dispose() {
  //
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Obx (() => AnimatedOpacity(
      opacity: homeController.visible.value,
      duration: Duration(milliseconds: 100),
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                elevation: 1.0,
                title: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropdownMain(
                            items: productController.myLocation,
                            value: productController.currentLocation.value,
                            onChange: (value) async {
                              if (value == "다른 위치 설정") {
                               await localhostServer.close();
                                await localhostServer.start();
                                KopoModel model = await Navigator.of(context)
                                    .push(PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) =>
                                      KakaoMap(),
                                ));
                                String position = await mapController.getPosition(model.address);
                                print("설정 주소 $position");
                                List<String> positionSplit = position.split(',');
                                await productController.getGeoSearch(double.parse(positionSplit[0]), double.parse(positionSplit[1]));
                                // await Provider.of<ProductController>(context,
                                //     listen: false)
                                //     .getGeoSearch(double.parse(positionSplit[0]),
                                //     );
                              } else{
                                 productController.getGeoChange(value);
                              }
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  Container(
                    padding: const EdgeInsets.only(right: 16),
                    child: IconButton(
                      icon: Image.asset('assets/icon/newSearch.png'),
                      onPressed: () => Navigator.pushNamed(context, '/search'),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
                  child: SingleChildScrollView(
                    controller: homeController.homeScroller,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: double.infinity,
                          height: 160.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BannerItem(false),
                          ),
                        ), // 배너 구간
                        MainCategory(), // 카테고리 구간
                        Container(
                          margin: const EdgeInsets.only(top: 0, bottom: 16, left: 10),
                          child: CustomDropdown(
                            items: itemKind,
                            value: homeController.currentItem.value,
                            onChange: (value) {
                                homeController.currentItem.value = value;
                                homeController.page.value = 0;
                            },
                          ),
                        ), // 빌려드려요 / 빌려주세요 드랍박스
                        ToItem(
                          value: homeController.currentItem.value,
                          page: homeController.page.value,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Container(
              //   child: BottomBar(),
              // ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class ToItem extends StatelessWidget {

  ProductController productController = Get.find<ProductController>();

  final String value;
  int page;

  ToItem({required this.value, required this.page});

  @override
  Widget build(BuildContext context) {
        return ListView.separated(
          itemCount: value == '빌려드려요'
              ? productController.mainProducts.length
              : productController.mainProductsWant.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, idx) {
            if (value == "빌려드려요") {
              return LendItemMainPage(
                category: "${_category(productController.mainProducts[idx].category_idx!)}",
                idx: productController.mainProducts[idx].idx,
                title: "${productController.mainProducts[idx].title}",
                name: "${productController.mainProducts[idx].name}",
                price: "${_moneyFormat("${productController.mainProducts[idx].price}")}원",
                distance:
                    "${(productController.mainProducts[idx].distance).toStringAsFixed(2)}",
                picture: "${productController.mainProducts[idx].image[0].file}",
                //receiverIdx: productController.mainProducts[idx].receiverIdx,
              );
            } else {
              return WantItemMainPage(
                idx: productController.mainProductsWant[idx].id,
                category:
                    "${_category(productController.mainProductsWant[idx].category)}",
                title: "${productController.mainProductsWant[idx].title}",
                name: "${productController.mainProductsWant[idx].name}",
                minPrice:
                    "${_moneyFormat("${productController.mainProductsWant[idx].minPrice}")}원",
                maxPrice:
                    "${_moneyFormat("${productController.mainProductsWant[idx].maxPrice}")}원",
                distance:
                    "${(productController.mainProductsWant[idx].distance).toStringAsFixed(2)}",
                startDate: _dateFormat(productController.mainProductsWant[idx].startDate),
                picture: "${productController.mainProductsWant[idx].productFiles[0].path}",
                endDate: _dateFormat(productController.mainProductsWant[idx].endDate),
              );
            }
          },
          separatorBuilder: (context, idx) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Divider(),
            );
          },
        );
  }
}

class MainCategory extends StatelessWidget {
  final List<Map<String, String>> TOP_CATEGORY = [
    {
      "생활용품": "assets/icon/category/household.png",
      "2": "2",
    },
    {
      "여행": "assets/icon/category/trip.png",
      "3": "3",
    },
    {
      "스포츠/레저": "assets/icon/category/sport.png",
      "4": "4",
    },
    {
      "육아": "assets/icon/category/parenting.png",
      "5": "5",
    },
    {
      "반려동물": "assets/icon/category/pet.png",
      "6": "6",
    },
  ];
  final List<Map<String, String>> CATEGORY = [
    {
      "가전제품": "assets/icon/category/laundry.png",
      "7": "7",
    },
    {
      "의류/잡화": "assets/icon/category/shopping.png",
      "8": "8",
    },
    {
      "가구/인테리어": "assets/icon/category/furniture.png",
      "9": "9",
    },
    {
      "자동차용품": "assets/icon/category/car.png",
      "10": "10",
    },
    {
      "기타": "assets/icon/category/etc.png",
      "11": "11",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10, top: 16),
            width: double.infinity,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0,
                  color: Colors.black.withOpacity(0.08),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: TOP_CATEGORY.map((e) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed("/category", arguments: {
                      "category": e.keys.first,
                      "categoryIdx": e.keys.last,
                    });
                  },
                  child: CategoryItem(
                    assets: e.values.first,
                    text: e.keys.first,
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: CATEGORY.map((e) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed("/category", arguments: {
                      "category": e.keys.first,
                      "categoryIdx": e.keys.last,
                    });
                  },
                  child: CategoryItem(
                    assets: e.values.first,
                    text: e.keys.first,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

_moneyFormat(String price) {
  if (price.length > 2) {
    var value = price;
    value = value.replaceAll(RegExp(r'\D'), '');
    value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
    return value;
  }else {
    return price;
  }
}

_dateFormat(String date) {
  String formatDate(DateTime date) => new DateFormat("MM/dd").format(date);
  return formatDate(DateTime.parse(date));
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

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
