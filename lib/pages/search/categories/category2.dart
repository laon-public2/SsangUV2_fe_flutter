import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  
  ProductController productController = Get.find<ProductController>();
  
  final List<String> itemKind = [
    "빌려드려요",
    "빌려주세요",
    "도와드려요",
  ];

  String _currentItem = "";
  int page = 0;
  ScrollController categoryScroller = ScrollController();

  categoryScrollerListener() async {
    final pvm = Provider.of<ProductController>(context, listen: false);
    if(categoryScroller.position.pixels == categoryScroller.position.maxScrollExtent){
      print("스크롤이 가장 아래입니다.");
      if(_currentItem == "빌려드려요"){
        print("빌려드려요 상태");
        if(pvm.searchPagingCa2.totalCount != pvm.searchDataProductCa2.length){
          print("검색 빌려드려요 more");
          this.page++;
          await pvm.SearchingDataProduct(
              page, this.widget.searchWord, this.widget._category, "RENT");
        }
      }else if(_currentItem == "빌려주세요"){
        print("빌려주세요 상태");
        if(pvm.searchPagingCa2.totalCount != pvm.searchDataProductWantCa2.length){
          this.page++;
          await pvm.SearchingDataProduct(
              page, this.widget.searchWord, this.widget._category, "WANT");
        }
      }
    }
  }

  @override
  void initState() {
    _currentItem = itemKind.first;
    super.initState();
    categoryScroller.addListener(categoryScrollerListener);
    asyncData();
  }

  void dispose() {
    categoryScroller.dispose();
    super.dispose();
  }

  void asyncData() async {
    await Provider.of<ProductController>(context, listen: false).SearchingDataProduct(
        this.page, this.widget.searchWord, this.widget._category, "RENT");
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
      controller: categoryScroller,
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
                    onChange: (value) async {
                      setState(() {
                        _currentItem = value;
                      });
                      if(value == "빌려드려요"){
                        await Provider.of<ProductController>(context, listen: false)
                            .SearchingDataProduct(
                            this.page, this.widget.searchWord, this.widget._category, "RENT");
                      }else if(value == "빌려주세요"){
                        await Provider.of<ProductController>(context, listen: false)
                            .SearchingDataProduct(
                            this.page, this.widget.searchWord, this.widget._category, "WANT");
                      }
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
    
     
        return ListView.separated(
          itemCount: this._currentItem == '빌려드려요'
              ? productController.searchDataProductCa2.length
              : productController.searchDataProductWantCa2.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, idx) {
            if (this._currentItem == "빌려드려요") {
              return LendItemMainPage(
                category: "${_category(productController.searchDataProductCa2[idx].category)}",
                idx: productController.searchDataProductCa2[idx].id,
                title: "${productController.searchDataProductCa2[idx].title}",
                name: "${productController.searchDataProductCa2[idx].name}",
                price: "${_moneyFormat("${productController.searchDataProductCa2[idx].price}")}원",
                distance:
                "${(productController.searchDataProductCa2[idx].distance).toStringAsFixed(2)}",
                picture: "${productController.searchDataProductCa2[idx].productFiles[0].path}",
              );
            } else {
              return WantItemMainPage(
                idx: productController.searchDataProductWantCa2[idx].id,
                category:
                "${_category(productController.searchDataProductWantCa2[idx].category)}",
                title: "${productController.searchDataProductWantCa2[idx].title}",
                name: "${productController.searchDataProductWantCa2[idx].name}",
                minPrice:
                "${_moneyFormat("${productController.searchDataProductWantCa2[idx].minPrice}")}원",
                maxPrice:
                "${_moneyFormat("${productController.searchDataProductWantCa2[idx].maxPrice}")}원",
                distance:
                "${(productController.searchDataProductWantCa2[idx].distance).toStringAsFixed(2)}",
                startDate: _dateFormat(productController.searchDataProductWantCa2[idx].startDate),
                endDate: _dateFormat(productController.searchDataProductWantCa2[idx].endDate),
                picture: productController.searchDataProductWantCa2[idx].productFiles[0].path,
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
