import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/myPageProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/CustomDropdown.dart';
import 'package:share_product_v2/widgets/CustomDropdownMain.dart';
import 'package:share_product_v2/widgets/lendItem.dart';
import 'package:share_product_v2/widgets/lendItemMyAct.dart';
import 'package:share_product_v2/widgets/rentItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../product/ProductDetail.dart';

class Category8 extends StatefulWidget {
  @override
  _Category1State createState() => _Category1State();
}

class _Category1State extends State<Category8> {
  final List<String> itemKind = ["빌려드려요", "빌려주세요", "거래요청해요"];

  int userIdx;
  int page;
  int category = 9;
  int totalCount;

  String _currentItem = "";
  @override
  void initState() {
    _currentItem = itemKind.first;
    super.initState();
    this.userIdx = Provider.of<UserProvider>(context, listen: false).userIdx;
    Provider.of<MyPageProvider>(context, listen: false)
        .getProWant(this.userIdx, page, category);
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
                  CustomDropdownMain(
                    items: itemKind,
                    value: _currentItem,
                    onChange: (value) {
                      setState(() {
                        _currentItem = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: _toItem(),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  _toItem() {
    return Consumer<UserProvider>(
      builder: (__, _myInfo, _){
        return Consumer<MyPageProvider>(
          builder: (_, _myActHistory, __) {
            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, idx) {
                if (_currentItem == "빌려드려요")
                  return LendItemMyAct(
                    category: '가구/인테리어',
                    title: '${_myActHistory.proRent[idx].title}',
                    name: _myActHistory.proRent[idx].name,
                    price: _moneyFormat("${_myActHistory.proRent[idx].price}"),
                    status: _myActHistory.proRent[idx].status,
                    idx: _myActHistory.proRent[idx].id,
                    picFile: _myActHistory.proRent[idx].productFiles[0].path,
                    arrayNum: idx,
                    token: _myInfo.accessToken,
                  );
                else if (_currentItem == '빌려주세요')
                  return RentItem(
                    category: "가구/인테리어",
                    title: "[사성 오피스] 사무실 대여 (누구나 대여 가능합니다.)",
                    name: "laonstory",
                    startPrice: "500,000",
                    endPrice: "650,000원",
                    startDate: "01/22",
                    endDate: "02/02",
                  );
                else
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductDetail()),
                  );
              },
              separatorBuilder: (context, idx) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Divider(),
                );
              },
              itemCount:
              _myActHistory.proRent == null ? 0 : _myActHistory.proRent.length,
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
    }
  }
}
