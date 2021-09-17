import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/product/ProductDetailRent.dart';
import 'package:share_product_v2/providers/mapProvider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/widgets/CustomDropdown.dart';
import 'package:share_product_v2/widgets/CustomDropdownMain.dart';
import 'package:share_product_v2/widgets/WantItemMainPage.dart';
import 'package:share_product_v2/widgets/banner.dart';
import 'package:share_product_v2/widgets/categoryItem.dart';
import 'package:share_product_v2/widgets/lendItemMainPage.dart';

import '../main.dart';
import 'KakaoMap.dart';
import 'chat/CustomerMessage.dart';

class HomePage extends StatefulWidget {
  double lati;
  double longti;

  HomePage({this.lati, this.longti});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CarouselController buttonCarouselController = CarouselController();

  int page = 0;
  final List<String> itemKind = [
    "빌려주세요",
    "빌려드려요",
    "도와주세요"
  ];
  String _currentItem = "";

  List<String> myLocation;
  String _currentLocation = "";

  List<String> address;

  ScrollController homeScroller = ScrollController();
  double _visible = 0.0;

  homeScrollerListener() async{
    final pvm = Provider.of<ProductProvider>(context, listen: false);
    if(homeScroller.position.pixels == homeScroller.position.maxScrollExtent){
      print("스크롤이 가장 아래입니다.");
      if(this._currentItem == "빌려드려요"){
        if(pvm.paging.totalCount != pvm.mainProducts.length){
          this.page++;
          Provider.of<ProductProvider>(context, listen: false)
              .getMainRent(this.page);
        }
      }else{
        if(pvm.paging.totalCount != pvm.mainProductsWant.length){
          this.page++;
          Provider.of<ProductProvider>(context, listen: false)
              .getMainWant(this.page);
        }
      }
    }
  }

  @override
  void initState() {
    _currentItem = itemKind.first;
    homeScroller.addListener(homeScrollerListener);
    super.initState();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        Platform.isIOS ?
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CustomerMessage(
              message['uuid'],
              int.parse(message['productIdx']),
              message['title'],
              message['category'],
              message['productOwner'],
              int.parse(message['price']),
              message['pic'],
              message['status'],
              int.parse(message['receiverIdx']),
              message['senderFcm'],
              message['receiverFcm'],
              int.parse(message['senderIdx']),
            )
        )):
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CustomerMessage(
              message['data']['uuid'],
              int.parse(message['data']['productIdx']),
              message['data']['title'],
              message['data']['category'],
              message['data']['productOwner'],
              int.parse(message['data']['price']),
              message['data']['pic'],
              message['data']['status'],
              int.parse(message['data']['receiverIdx']),
              message['data']['senderFcm'],
              message['data']['receiverFcm'],
              int.parse(message['data']['senderIdx']),
            )
        ));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _visible = 1.0;
      });
    });
  }

  void dispose() {
    homeScroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible,
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
                      Consumer<ProductProvider>(
                        builder: (__, _myProduct, _) {
                          return CustomDropdownMain(
                            items: _myProduct.myLocation,
                            value: _myProduct.currentLocation,
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
                                String position = await Provider.of<MapProvider>(
                                    context,
                                    listen: false)
                                    .getPosition(model.address);
                                print("설정 주소 $position");
                                List<String> positionSplit = position.split(',');
                                await Provider.of<ProductProvider>(context,
                                    listen: false)
                                    .getGeoSearch(double.parse(positionSplit[0]),
                                    double.parse(positionSplit[1]));
                              }else{
                                _myProduct.getGeoChange(value);
                              }
                            },
                          );
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
                    controller: homeScroller,
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
                            value: _currentItem,
                            onChange: (value) {
                              setState(() {
                                _currentItem = value;
                                this.page = 0;
                              });
                            },
                          ),
                        ), // 빌려드려요 / 빌려주세요 드랍박스
                        ToItem(
                          value: _currentItem,
                          page: this.page,
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
    );
  }
}

class ToItem extends StatelessWidget {
  final String value;
  int page;

  ToItem({this.value, this.page});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (_, _myList, __) {
        return ListView.separated(
          itemCount: value == '빌려드려요'
              ? _myList.mainProducts.length
              : _myList.mainProductsWant.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, idx) {
            if (value == "빌려드려요") {
              return LendItemMainPage(
                category: "${_category(_myList.mainProducts[idx].category)}",
                idx: _myList.mainProducts[idx].id,
                title: "${_myList.mainProducts[idx].title}",
                name: "${_myList.mainProducts[idx].name}",
                price: "${_moneyFormat("${_myList.mainProducts[idx].price}")}원",
                distance:
                    "${(_myList.mainProducts[idx].distance).toStringAsFixed(2)}",
                picture: "${_myList.mainProducts[idx].productFiles[0].path}",
                receiverIdx: _myList.mainProducts[idx].receiverIdx,
              );
            } else {
              return WantItemMainPage(
                idx: _myList.mainProductsWant[idx].id,
                category:
                    "${_category(_myList.mainProductsWant[idx].category)}",
                title: "${_myList.mainProductsWant[idx].title}",
                name: "${_myList.mainProductsWant[idx].name}",
                minPrice:
                    "${_moneyFormat("${_myList.mainProductsWant[idx].minPrice}")}원",
                maxPrice:
                    "${_moneyFormat("${_myList.mainProductsWant[idx].maxPrice}")}원",
                distance:
                    "${(_myList.mainProductsWant[idx].distance).toStringAsFixed(2)}",
                startDate: _dateFormat(_myList.mainProductsWant[idx].startDate),
                picture: "${_myList.mainProductsWant[idx].productFiles[0].path}",
                endDate: _dateFormat(_myList.mainProductsWant[idx].endDate),
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
