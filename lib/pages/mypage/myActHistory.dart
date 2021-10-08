import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
import 'package:share_product_v2/providers/myPageController.dart';
import 'package:share_product_v2/providers/userController.dart';

class MyActHistory extends StatefulWidget {
  const MyActHistory({Key? key}) : super(key:key);
  @override
  _MyActHistoryState createState() => _MyActHistoryState();
}

class _MyActHistoryState extends State<MyActHistory> with SingleTickerProviderStateMixin{
  late TabController controller;
  MyPageController myPageController = Get.put(MyPageController());
  List<Tab> myTabs = <Tab> [
    Tab(text: '전체'),
    Tab(text: '생활용품'),
    Tab(text: '여행'),
    Tab(text: '스포츠/레저'),
    Tab(text: '육아'),
    Tab(text: '반려동물'),
    Tab(text: '가전제품'),
    Tab(text: '의류/잡화'),
    Tab(text: '가구/인테리어'),
    Tab(text: '자동차용품'),
    Tab(text: '기타'),
  ];

  void initState() {
    super.initState();
    controller = new TabController(length: 11, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: TabBar(
          isScrollable: true,
          unselectedLabelColor: Color(0xff999999),
          labelColor: Color(0xff333333),
          indicatorColor: Color(0xffff0066),
          controller: controller,
          tabs: myTabs.map((Tab tab){
            return Tab(child: _CustomTabBarText(tab.text!));
          }).toList(),
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
                child: GetBuilder<UserController>(
                  builder: (myact) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: myact.userProfileImg.value.length != 0 ? Image.network(
                        "http://115.91.73.66:15066/assets/images/user/${myact.userProfileImg}",
                        height: 27.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ) : Container(),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              GetBuilder<UserController>(
                builder: (myact) {
                  return Text(
                    myact.username.value,
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
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _body(),
    );
  }


  Widget _body() {
    return TabBarView(
      controller: controller,
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
