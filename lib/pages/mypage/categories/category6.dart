import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/auth/myPage.dart';
import 'package:share_product_v2/providers/myPageController.dart';
import 'package:share_product_v2/providers/userController.dart';
import 'package:share_product_v2/widgets/CustomDropdown.dart';
import 'package:share_product_v2/widgets/CustomDropdownMain.dart';
import 'package:share_product_v2/widgets/WantItemMainPage.dart';
import 'package:share_product_v2/widgets/WantItemMyAct.dart';
import 'package:share_product_v2/widgets/lendItem.dart';
import 'package:share_product_v2/widgets/lendItemMyAct.dart';
import 'package:share_product_v2/widgets/loading.dart';
import 'package:share_product_v2/widgets/loading2.dart';
import 'package:share_product_v2/widgets/rentItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../product/ProductDetail.dart';

//futureBuilder 제작 해야함.

class Category6 extends StatefulWidget {
  @override
  _Category1State createState() => _Category1State();
}

class _Category1State extends State<Category6> {
  final List<String> itemKind = ["빌려드려요", "빌려주세요"];
  UserController userController = Get.find<UserController>();

  MyPageController myPageController = Get.find<MyPageController>();
  late int page;
  int category = 7;
  late int totalCount;

  String _currentItem = "";

  @override
  void initState() {
    _currentItem = itemKind.first;
    super.initState();
  }

  Future<bool>_loadingProduct() async {
    int userIdx = userController.userIdx.value;
    await myPageController
        .getProWantCa6(userIdx, page, category);
    await myPageController
        .getProRentCa6(userIdx, page, category);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(),
    );
  }


  _body() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  CustomDropdown(
                    items: itemKind,
                    value: _currentItem,
                    onChange: (value) {
                      if(value == "거래요청해요"){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductDetail()),
                        );
                      }else{
                        setState(() {
                          _currentItem = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: FutureBuilder(
                future: _loadingProduct(),
                builder: (context, snapshot) {
                  if (snapshot.hasData == false) {
                    return Container(
                      height: 300.h,
                      color: Colors.white,
                      child: Center(
                        child: Loading2(),
                      ),
                    );
                  }else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  } else {
                    return _toItem();
                  }
                },
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  _toItem() {
    return GetBuilder<UserController>(
      builder: (_myInfo) {
        return GetBuilder<MyPageController>(
          builder: (_myActHistory) {
            return ListView.separated(
              itemCount: _currentItem == '빌려드려요'
                  ? _myActHistory.proRentCa6.length
                  : _myActHistory.proWantCa6.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, idx) {
                if (_currentItem == "빌려드려요") {
                  return LendItemMyAct(
                    category: '가전제품',
                    title: '${_myActHistory.proRentCa6[idx].title}',
                    name: _myActHistory.proRentCa6[idx].name,
                    price: _moneyFormat("${_myActHistory.proRentCa6[idx].price}"),
                    status: _myActHistory.proRentCa6[idx].status,
                    idx: _myActHistory.proRentCa6[idx].idx,
                    picFile: _myActHistory.proRentCa6[idx].image[0].file,
                    arrayNum: idx,
                    token: _myInfo.accessToken.value,
                  );
                } else if (_currentItem == '빌려주세요') {
                  return WantItemMyAct(
                    idx: _myActHistory.proWantCa6[idx].idx,
                    category:
                    "가전제품",
                    title: "${_myActHistory.proWantCa6[idx].title}",
                    name: "${_myActHistory.proWantCa6[idx].name}",
                    minPrice: "${_moneyFormat("${_myActHistory.proWantCa6[idx].min_price}")}원",
                    maxPrice: "${_moneyFormat("${_myActHistory.proWantCa6[idx].max_price}")}원",
                    startDate: _dateFormat(_myActHistory.proWantCa6[idx].start_date),
                    endDate: _dateFormat(_myActHistory.proWantCa6[idx].end_date),
                    picture: _myActHistory.proWantCa6[idx].image[0].file,
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductDetail()),
                  );
                  return Container();
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
      },
    );
  }

  _moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }else{
      return price;
    }
  }

  _dateFormat(String date) {
    String formatDate(DateTime date) => new DateFormat("MM/dd").format(date);
    return formatDate(DateTime.parse(date));
  }
}
