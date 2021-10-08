import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/search/categories/category1.dart';
import 'package:share_product_v2/pages/search/categories/category10.dart';
import 'package:share_product_v2/pages/search/categories/category3.dart';
import 'package:share_product_v2/pages/search/categories/category4.dart';
import 'package:share_product_v2/pages/search/categories/category5.dart';
import 'package:share_product_v2/pages/search/categories/category6.dart';
import 'package:share_product_v2/pages/search/categories/category7.dart';
import 'package:share_product_v2/pages/search/categories/category9.dart';
import 'package:share_product_v2/providers/productController.dart';

import 'categories/category2.dart';
import 'categories/category8.dart';

class SearchData extends StatefulWidget {
  @override
  _SearchDataState createState() => _SearchDataState();
}

class _SearchDataState extends State<SearchData> {
  int _category = 2;
  TextEditingController _searchWord = TextEditingController();
  ProductController productController = Get.find<ProductController>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 10,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            physics: NeverScrollableScrollPhysics(),
            isScrollable: true,
            unselectedLabelColor: Color(0xff444444),
            labelColor: Color(0xffff0066),
            indicatorColor: Color(0xffff0066),
            tabs: <Widget>[
              Tab(
                child: _CustomTabBarText('생활용품'),
              ),
              Tab(
                child: _CustomTabBarText('여행'),
              ),
              Tab(
                child: _CustomTabBarText('스포츠/레저'),
              ),
              Tab(
                child: _CustomTabBarText('육아'),
              ),
              Tab(
                child: _CustomTabBarText('반려동물'),
              ),
              Tab(
                child: _CustomTabBarText('가전제품'),
              ),
              Tab(
                child: _CustomTabBarText('의류/잡화'),
              ),
              Tab(
                child: _CustomTabBarText('가구/인테리어'),
              ),
              Tab(
                child: _CustomTabBarText('자동차용품'),
              ),
              Tab(
                child: _CustomTabBarText('기타'),
              ),
            ],
          ),
          elevation: 1.0,
          // centerTitle: true,
          title: Container(
            width: double.infinity,
            height: 35.h,
            decoration: BoxDecoration(
              color: Color(0xfff2f2f2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Center(
                    child: IconButton(
                      icon: Image.asset('assets/icon/newSearch.png'),
                      onPressed: () {
                        productController
                            .SearchingDataProduct(0, _searchWord.text, _category, "RENT");
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: _searchWord,
                      decoration: InputDecoration.collapsed(
                        hintText: '검색어를 입력하세요.',
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.go,
                      onSubmitted: _handleSubmitted,
                    ),
                  ),
                )
              ],
            ),
          ),
          leadingWidth: 30.w,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_sharp,
              color: Colors.black,
              size: 30.0,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: Center(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _searchWord.text = "";
                    });
                  },
                  child: Text(
                    '취소',
                    style: TextStyle(color: Color(0xff666666), fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: _body(),
      ),
    );
  }
  Widget _body() {
    return TabBarView(
      children: [
        Category1(_searchWord.text),
        Category2(_searchWord.text),
        Category3(_searchWord.text),
        Category4(_searchWord.text),
        Category5(_searchWord.text),
        Category6(_searchWord.text),
        Category7(_searchWord.text),
        Category8(_searchWord.text),
        Category9(_searchWord.text),
        Category10(_searchWord.text),
      ],
    );
  }

  _CustomTabBarText(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xff333333),
          fontSize: 14,
        ),
      ),
    );
  }

  void _handleSubmitted(String text){
    if(_searchWord.text.trim().isEmpty) return null;
    productController
        .SearchingDataProduct(0, _searchWord.text, _category, "RENT");
  }
}
