import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/mypage/categories/category0.dart';
import 'package:share_product_v2/pages/mypage/categories/category1.dart';
import 'package:share_product_v2/pages/mypage/categories/category10.dart';
import 'package:share_product_v2/pages/mypage/categories/category2.dart';
import 'package:share_product_v2/pages/mypage/categories/category3.dart';
import 'package:share_product_v2/pages/mypage/categories/category4.dart';
import 'package:share_product_v2/pages/mypage/categories/category5.dart';
import 'package:share_product_v2/pages/mypage/categories/category6.dart';
import 'package:share_product_v2/pages/mypage/categories/category7.dart';
import 'package:share_product_v2/pages/mypage/categories/category8.dart';
import 'package:share_product_v2/pages/mypage/categories/category9.dart';
import 'package:share_product_v2/providers/userProvider.dart';

class MyActHistory extends StatefulWidget {
  @override
  _MyActHistoryState createState() => _MyActHistoryState();
}

class _MyActHistoryState extends State<MyActHistory> {
  TextEditingController _searchWord = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 11,
      child: Scaffold(
        appBar: _appBar(),
        body: _body(),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      bottom: TabBar(
        isScrollable: true,
        unselectedLabelColor: Color(0xff444444),
        labelColor: Color(0xffff0066),
        indicatorColor: Color(0xffff0066),
        tabs: <Widget>[
          Tab(
            child: _CustomTabBarText('전체'),
          ),
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
      centerTitle: true,
      title: Container(
        padding: const EdgeInsets.only(right: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 27.w,
              height: 27.h,
              child: Consumer<UserProvider>(
                builder: (_, myact, __) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      "http://192.168.100.232:5066/assets/images/user/${myact.userProfileImg}",
                      height: 27.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Consumer<UserProvider>(
              builder: (_, myact, __) {
                return Text(
                  myact.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xff666666),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_sharp,
          color: Colors.black,
          size: 30.0,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _body() {
    return TabBarView(
      children: [
        Category0(),
        Category1(),
        Category2(),
        Category3(),
        Category4(),
        Category5(),
        Category6(),
        Category7(),
        Category8(),
        Category9(),
        Category10(),
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
}
