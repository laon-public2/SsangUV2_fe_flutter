import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/model/paging.dart';
import 'package:share_product_v2/model/product.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/utils/ConvertNumberFormat.dart';
import 'package:share_product_v2/widgets/BackBtn.dart';
import 'package:share_product_v2/widgets/WantItemMainPage.dart';
import 'package:share_product_v2/widgets/categoryText.dart';
import 'package:share_product_v2/widgets/customText.dart';
import 'package:share_product_v2/widgets/lendItemMainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class CategoryProductList extends StatefulWidget {
  // final String title;
  @override
  _CategoryProductListState createState() => _CategoryProductListState();
}

class _CategoryProductListState extends State<CategoryProductList> {
  Geolocator? geolocator;
  bool _want = false;
  bool _rent = true;
  bool _help = false;
  String userType = "Rent";
  var category = "";
  var keyword = "";
  double? latitude;
  double? longitude;
  int page = 0;
  Paging? paging;
  String? categoryIdx;

  ScrollController categoryScroll = ScrollController();

  categoryScrollerListener() async {
    final pvm = Provider.of<ProductProvider>(context, listen: false);
    if (categoryScroll.position.pixels ==
        categoryScroll.position.maxScrollExtent) {
      print("스크롤이 가장 아래입니다.");
      if (this.userType == "Rent") {
        if (pvm.paging.totalCount != pvm.categoryProducts.length) {
          this.page++;
          pvm.categoryRent(categoryIdx!, page, userType);
        }
      } else {
        if (pvm.paging.totalCount != pvm.categoryProducts.length) {
          this.page++;
          pvm.categoryWant(categoryIdx!, page, userType);
        }
      }
    }
  }

  _getProduct() async {
    Provider.of<ProductProvider>(context, listen: false)
        .categoryRent(categoryIdx!, page, userType);
  }

  @override
  void initState() {
    super.initState();
    categoryScroll.addListener(categoryScrollerListener);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _getProduct();
      print(
          "배열 갯수 === ${Provider.of<ProductProvider>(context, listen: false).categoryProducts.length}");
    });
  }

  void dispose() {
    categoryScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    setState(() {
      categoryIdx = args['categoryIdx'];
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        title: CustomText(
          text: args["keyword"] == null ? args["category"] : args["keyword"],
          fontSize: 16.sp,
          textColor: Colors.black,
        ),
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: BackBtn(),
        backgroundColor: Colors.white,
        // TODO: 해당 부분은 카테고리에서 검색하는 부분인데 나중에 추가하자구
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20.0),
        //     child: IconButton(
        //       icon: Icon(Icons.search),
        //       color: Color(0xff333333),
        //       iconSize: 24.w,
        //       onPressed: () {
        //         Navigator.of(context).pushNamed("/search", arguments: { "category" : args["category"]});
        //       },
        //     ),
        //   ),
        // ],
        // bottom: PreferredSize( 기능 삭제. n차 개발
        //   preferredSize: Size.fromHeight(32.h),
        //   child: Consumer<ProductProvider>(
        //     builder: (__, _myProduct, _){
        //       return InkWell(
        //         onTap: () async {
        //           dynamic returnData = await Navigator.of(context).pushNamed(
        //               "/address",
        //               arguments: {latitude: "${_myProduct.la}", longitude: "${_myProduct.lo}"});
        //         },
        //         child: Container(
        //           width: double.infinity,
        //           height: 32.h,
        //           margin: const EdgeInsets.all(10.0),
        //           decoration: BoxDecoration(
        //             color: Color(0xffF8F8F8),
        //             borderRadius: BorderRadius.circular(2),
        //           ),
        //           child: Padding(
        //             padding: const EdgeInsets.only(left: 10.0),
        //             child:
        //             Align(alignment: Alignment.centerLeft, child: Text("지역")),
        //           ),
        //         ),
        //       );
        //     },
        //   )
        // ),
      ),
      body: Container(color: Colors.white, child: _body()),
    );
  }

  _body() {
    final Map<String, String> args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return SingleChildScrollView(
      controller: categoryScroll,
      child: Consumer<ProductProvider>(builder: (_, product, __) {
        this.paging = product.paging;
        return Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.only(right: 16, left: 16, top: 20),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                width: args['category'] == "기타" ? double.infinity : 211.w,
                child: args['category'] == "기타" ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: Text(
                        '빌려드려요',
                        style: TextStyle(
                          color: _rent ? Colors.black : Color(0xff999999),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _want = false;
                          _rent = true;
                          _help = false;
                          userType = "Rent";
                        });
                        Provider.of<ProductProvider>(context, listen: false)
                            .categoryRent(categoryIdx!, page, userType);
                      },
                    ),
                    Text(
                      '|',
                      style: TextStyle(
                        color: Color(0xff999999),
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _want = true;
                          _rent = false;
                          _help = false;
                          userType = "Want";
                        });
                        Provider.of<ProductProvider>(context, listen: false)
                            .categoryWant(categoryIdx!, page, userType);
                      },
                      child: Text(
                        '빌려주세요',
                        style: TextStyle(
                          color: _want ? Colors.black : Color(0xff999999),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      '|',
                      style: TextStyle(
                        color: Color(0xff999999),
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _help = true;
                          _rent = false;
                          _want = false;
                          userType = "HELP";
                        });
                        Provider.of<ProductProvider>(context, listen: false)
                            .categoryWant(categoryIdx!, page, userType);
                      },
                      child: Text(
                        '도와드려요',
                        style: TextStyle(
                          color: _help ? Colors.black : Color(0xff999999),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ):
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Text(
                        '빌려드려요',
                        style: TextStyle(
                          color: _rent ? Colors.black : Color(0xff999999),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _want = false;
                          _rent = true;
                          userType = "Rent";
                        });
                        Provider.of<ProductProvider>(context, listen: false)
                            .categoryRent(categoryIdx!, page, userType);
                      },
                    ),
                    Text(
                      '|',
                      style: TextStyle(
                        color: Color(0xff999999),
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _want = true;
                          _rent = false;
                          userType = "Want";
                        });
                        Provider.of<ProductProvider>(context, listen: false)
                            .categoryWant(categoryIdx!, page, userType);
                      },
                      child: Text(
                        '빌려주세요',
                        style: TextStyle(
                          color: _want ? Colors.black : Color(0xff999999),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              // makeList(context, product.products),
              _toItem(),
            ],
          ),
        );
      }),
    );
  }

  _toItem() {
    return Consumer<ProductProvider>(
      builder: (_, _myList, __) {
        return ListView.separated(
          itemCount: !_want
              ? _myList.categoryProducts.length
              : _myList.categoryProductsWant.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, idx) {
            if (!_want) {
              return LendItemMainPage(
                category:
                    "${_category(_myList.categoryProducts[idx].category)}",
                idx: _myList.categoryProducts[idx].id,
                title: "${_myList.categoryProducts[idx].title}",
                name: "${_myList.categoryProducts[idx].name}",
                price:
                    "${_moneyFormat("${_myList.categoryProducts[idx].price}")}원",
                distance:
                    "${(_myList.categoryProducts[idx].distance).toStringAsFixed(2)}",
                picture: _myList.categoryProducts[idx].productFiles[0].path,
              );
            } else {
              return WantItemMainPage(
                idx: _myList.categoryProductsWant[idx].id,
                category:
                    "${_category(_myList.categoryProductsWant[idx].category)}",
                title: "${_myList.categoryProductsWant[idx].title}",
                name: "${_myList.categoryProductsWant[idx].name}",
                minPrice:
                    "${_moneyFormat("${_myList.categoryProductsWant[idx].minPrice}")}원",
                maxPrice:
                    "${_moneyFormat("${_myList.categoryProductsWant[idx].maxPrice}")}원",
                distance:
                    "${(_myList.categoryProductsWant[idx].distance).toStringAsFixed(2)}",
                startDate:
                    _dateFormat(_myList.categoryProductsWant[idx].startDate),
                endDate: _dateFormat(_myList.categoryProductsWant[idx].endDate),
                picture: _myList.categoryProductsWant[idx].productFiles[0].path,
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

_moneyFormat(String price) {
  if (price.length > 2) {
    var value = price;
    value = value.replaceAll(RegExp(r'\D'), '');
    value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
    return value;
  } else {
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
    String value = '여행';
    return value;
  } else if (categoryNum == 4) {
    String value = '스포츠/레저';
    return value;
  } else if (categoryNum == 5) {
    String value = '육아';
    return value;
  } else if (categoryNum == 6) {
    String value = '반려동물';
    return value;
  } else if (categoryNum == 7) {
    String value = '가전제품';
    return value;
  } else if (categoryNum == 8) {
    String value = '의류/잡화';
    return value;
  } else if (categoryNum == 9) {
    String value = '가구/인테리어';
    return value;
  } else if (categoryNum == 10) {
    String value = '자동차용품';
    return value;
  } else {
    String value = '기타';
    return value;
  }
}
