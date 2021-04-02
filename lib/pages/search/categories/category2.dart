import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/widgets/CustomDropdown.dart';
import 'package:share_product_v2/widgets/CustomDropdownMain.dart';
import 'package:share_product_v2/widgets/WantItemMainPage.dart';
import 'package:share_product_v2/widgets/lendItem.dart';
import 'package:share_product_v2/widgets/lendItemMainPage.dart';
import 'package:share_product_v2/widgets/rentItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Category2 extends StatefulWidget {
  int _category = 3;
  final String searchWord;
  Category2(this.searchWord);
  @override
  _Category1State createState() => _Category1State();
}

class _Category1State extends State<Category2> {
  final List<String> itemKind = [
    "빌려드려요",
    "빌려주세요",
  ];

  String _currentItem = "";
  int page = 0;
  @override
  void initState() {
    _currentItem = itemKind.first;
    super.initState();
    asyncData();
  }
  void asyncData() async {
    await Provider.of<ProductProvider>(context, listen: false).SearchingDataProduct(
        this.page, this.widget.searchWord, this.widget._category);
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
    return Consumer<ProductProvider>(
      builder: (_, _myList, __) {
        return ListView.separated(
          itemCount: this._currentItem == '빌려드려요'
              ? _myList.searchDataProductCa2.length
              : _myList.searchDataProductWantCa2.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, idx) {
            if (this._currentItem == "빌려드려요") {
              if (idx == _myList.searchDataProductCa2.length) {
                if (idx == _myList.searchPagingCa2.totalCount) {
                  return SizedBox();
                } else {
                  this.page++;
                  Provider.of<ProductProvider>(context, listen: false).
                  SearchingDataProduct(this.page, this.widget.searchWord, this.widget._category);
                }
              }
              return LendItemMainPage(
                category: "${_category(_myList.searchDataProductCa2[idx].category)}",
                idx: _myList.searchDataProductCa2[idx].id,
                title: "${_myList.searchDataProductCa2[idx].title}",
                name: "${_myList.searchDataProductCa2[idx].name}",
                price: "${_moneyFormat("${_myList.searchDataProductCa2[idx].price}")}원",
                distance:
                "${(_myList.searchDataProductCa2[idx].distance).toStringAsFixed(2)}",
                picture: "${_myList.searchDataProductCa2[idx].productFiles[0].path}",
              );
            } else {
              if (idx == _myList.mainProductsWant.length) {
                if (idx == _myList.paging.totalCount) {
                  return Container();
                } else {
                  this.page++;
                  Provider.of<ProductProvider>(context, listen: false)
                      .getMainWant(this.page);
                }
              }
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

_moneyFormat(String price) {
  if (price.length > 2) {
    var value = price;
    value = value.replaceAll(RegExp(r'\D'), '');
    value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
    return value;
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
