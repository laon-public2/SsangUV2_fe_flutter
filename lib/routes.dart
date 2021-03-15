import 'package:flutter/cupertino.dart';
import 'package:share_product_v2/pages/product/ProductRegOner.dart';
import 'package:share_product_v2/pages/product/ProductReg.dart';
import 'package:share_product_v2/pages/auth/choiceUser.dart';
import 'package:share_product_v2/pages/auth/login.dart';
import 'package:share_product_v2/pages/auth/loginMyPage.dart';
import 'package:share_product_v2/pages/auth/myPage.dart';
import 'package:share_product_v2/pages/categories/categoriesPage.dart';
import 'package:share_product_v2/pages/chat/chatting.dart';
import 'package:share_product_v2/pages/main.dart';
import 'package:share_product_v2/pages/mainpage.dart';
import 'package:share_product_v2/pages/mypage/loginpage_use_phone.dart';
import 'package:share_product_v2/pages/mypage/myActHistory.dart';
import 'package:share_product_v2/pages/mypage/myproductpage.dart';
import 'package:share_product_v2/pages/mypage/noticepage.dart';
import 'package:share_product_v2/pages/mypage/policydetailpage.dart';
import 'package:share_product_v2/pages/mypage/policypage.dart';
import 'package:share_product_v2/pages/product/productApplyPage.dart';
import 'package:share_product_v2/pages/search/categoryPage.dart';
import 'package:share_product_v2/pages/search/searchData.dart';
import 'package:share_product_v2/pages/splashpage.dart';
import 'package:share_product_v2/pages/search/address.dart' as f;

final routes = {
  "/main": (BuildContext context) => MainPage(),
  "/category": (BuildContext context) => CategoryProductList(),
  // "/main": (context) => MainPage(),
  // "/home": (context) => MainPage(),
  // 상품관련
  // "/product": (BuildContext context) => DetailProduct(),
  "/product/apply": (context) => ProductReg(),
  "/product/applyOnerWhatever": (context) => ProductApplyPage(),
  // '/product/applyOner': (context) => ProductRegSecond(),
  '/search': (BuildContext context) => SearchData(),
  // "/product/detail": (context) => DetailProduct(),
  // MyPage 관련
  '/chioceUser': (context) => ChoiceUser(),
  "/loggedPage": (context) => LoginMyPage(),
  "/loginNode": (context) => LoginPageNode(),
  '/myPageInit': (context) => MyPage(),
  // '/members/product': (context) => MyProductPage(), 삭제된 기능. 쓰지 않습니더.
  // "/user" : (context) => UserPage(),
  '/myActHistory': (context) => MyActHistory(),
  "/notice": (context) => NoticePage(),
  // "/center": (context) => CenterPage(),
  "/policy": (context) => PolicyPage(),
  "/policy/detail": (context) => PolicyDetailPage(),
  "/user/product": (context) => MyProductPage(),
  // "/withdraw" : (context) => WithdrawPage(),
  // "/loginPage": (context) => LoginPage(),
  // //채팅
  "/chatting": (context) => Chatting(),
  // //계약
  // "/contract": (context) => Contract(),
  // "/contract/form": (context) => ContractForm(),
  // "/contract/complete": (context) => ContractComplete(),
  // "/contract/complete/form": (context) => ContractCompleteForm(),
  // //지역
  "/address": (context) => f.Address(),
  // "/address/search": (context) => SearchAddress(),
  // "/search": (context) => Search(),

  "/": (context) => SplashScreen(),
};
