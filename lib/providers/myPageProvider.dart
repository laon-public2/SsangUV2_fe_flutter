import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_product_v2/model/productMyActRent.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/providers/userProvider.dart';

import 'package:share_product_v2/services/productService.dart';

class MyPageProvider extends ChangeNotifier {
  final ProductService productSv = ProductService();

  //카테고리 0
  List<ProductMyActRent> proRent = [];
  List<ProductMyActRent> proWant = [];
  //카테고리 1
  List<ProductMyActRent> proRentCa1 = [];
  List<ProductMyActRent> proWantCa1 = [];
  //카테고리 2
  List<ProductMyActRent> proRentCa2 = [];
  List<ProductMyActRent> proWantCa2 = [];
  //카테고리 3
  List<ProductMyActRent> proRentCa3 = [];
  List<ProductMyActRent> proWantCa3 = [];
  //카테고리 4
  List<ProductMyActRent> proRentCa4 = [];
  List<ProductMyActRent> proWantCa4 = [];
  //카테고리 5
  List<ProductMyActRent> proRentCa5 = [];
  List<ProductMyActRent> proWantCa5 = [];
  //카테고리 6
  List<ProductMyActRent> proRentCa6 = [];
  List<ProductMyActRent> proWantCa6 = [];
  //카테고리 7
  List<ProductMyActRent> proRentCa7 = [];
  List<ProductMyActRent> proWantCa7 = [];
  //카테고리 8
  List<ProductMyActRent> proRentCa8 = [];
  List<ProductMyActRent> proWantCa8 = [];
  //카테고리 9
  List<ProductMyActRent> proRentCa9 = [];
  List<ProductMyActRent> proWantCa9 = [];
  //카테고리 10
  List<ProductMyActRent> proRentCa10 = [];
  List<ProductMyActRent> proWantCa10 = [];

  //카테고리 0 서버데이터
  Future<void> getProRent(int userIdx, int page, int category) async {
    print("나의 활동 빌려드려요.");
    this.proRent = [];
    final res = await productSv.getProRent(userIdx, page, category, "RENT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proRent = datas;
    notifyListeners();
  }
  Future<void> getProWant(int userIdx, int page, int category) async {
    print("나의 활동 빌려주세요");
    this.proWant = [];
    final res = await productSv.getProRent(userIdx, page, category, "WANT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proWant = datas;
    notifyListeners();
  }

  //카테고리 1 서버데이터
  Future<void> getProRentCa1(int userIdx, int page, int category) async {
    print("나의 활동 빌려드려요.");
    this.proRentCa1 = [];
    final res = await productSv.getProRent(userIdx, page, category, "RENT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proRentCa1 = datas;
    notifyListeners();
  }
  Future<void> getProWantCa1(int userIdx, int page, int category) async {
    print("나의 활동 빌려주세요");
    this.proWantCa1 = [];
    final res = await productSv.getProRent(userIdx, page, category, "WANT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proWantCa1 = datas;
    notifyListeners();
  }

  //카테고리 2 서버데이터
  Future<void> getProRentCa2(int userIdx, int page, int category) async {
    print("나의 활동 빌려드려요.");
    this.proRentCa2 = [];
    final res = await productSv.getProRent(userIdx, page, category, "RENT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proRentCa2 = datas;
    notifyListeners();
  }
  Future<void> getProWantCa2(int userIdx, int page, int category) async {
    print("나의 활동 빌려주세요");
    this.proWantCa2 = [];
    final res = await productSv.getProRent(userIdx, page, category, "WANT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proWantCa2 = datas;
    notifyListeners();
  }

  //카테고리 3 서버데이터
  Future<void> getProRentCa3(int userIdx, int page, int category) async {
    print("나의 활동 빌려드려요.");
    this.proRentCa3 = [];
    final res = await productSv.getProRent(userIdx, page, category, "RENT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proRentCa3 = datas;
    notifyListeners();
  }
  Future<void> getProWantCa3(int userIdx, int page, int category) async {
    print("나의 활동 빌려주세요");
    this.proWantCa3 = [];
    final res = await productSv.getProRent(userIdx, page, category, "WANT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proWantCa3 = datas;
    notifyListeners();
  }

  //카테고리 4 서버데이터
  Future<void> getProRentCa4(int userIdx, int page, int category) async {
    print("나의 활동 빌려드려요.");
    this.proRentCa4 = [];
    final res = await productSv.getProRent(userIdx, page, category, "RENT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proRentCa4 = datas;
    notifyListeners();
  }
  Future<void> getProWantCa4(int userIdx, int page, int category) async {
    print("나의 활동 빌려주세요");
    this.proWantCa4 = [];
    final res = await productSv.getProRent(userIdx, page, category, "WANT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proWantCa4 = datas;
    notifyListeners();
  }

  //카테고리 5 서버데이터
  Future<void> getProRentCa5(int userIdx, int page, int category) async {
    print("나의 활동 빌려드려요.");
    this.proRentCa5 = [];
    final res = await productSv.getProRent(userIdx, page, category, "RENT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proRentCa5 = datas;
    notifyListeners();
  }
  Future<void> getProWantCa5(int userIdx, int page, int category) async {
    print("나의 활동 빌려주세요");
    this.proWantCa5 = [];
    final res = await productSv.getProRent(userIdx, page, category, "WANT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proWantCa5 = datas;
    notifyListeners();
  }

  //카테고리 6 서버데이터
  Future<void> getProRentCa6(int userIdx, int page, int category) async {
    print("나의 활동 빌려드려요.");
    this.proRentCa6 = [];
    final res = await productSv.getProRent(userIdx, page, category, "RENT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proRentCa6 = datas;
    notifyListeners();
  }
  Future<void> getProWantCa6(int userIdx, int page, int category) async {
    print("나의 활동 빌려주세요");
    this.proWantCa6 = [];
    final res = await productSv.getProRent(userIdx, page, category, "WANT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proWantCa6 = datas;
    notifyListeners();
  }

  //카테고리 7 서버데이터
  Future<void> getProRentCa7(int userIdx, int page, int category) async {
    print("나의 활동 빌려드려요.");
    this.proRentCa7 = [];
    final res = await productSv.getProRent(userIdx, page, category, "RENT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proRentCa7 = datas;
    notifyListeners();
  }
  Future<void> getProWantCa7(int userIdx, int page, int category) async {
    print("나의 활동 빌려주세요");
    this.proWantCa7 = [];
    final res = await productSv.getProRent(userIdx, page, category, "WANT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proWantCa7 = datas;
    notifyListeners();
  }

  //카테고리 8 서버데이터
  Future<void> getProRentCa8(int userIdx, int page, int category) async {
    print("나의 활동 빌려드려요.");
    this.proRentCa8 = [];
    final res = await productSv.getProRent(userIdx, page, category, "RENT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proRentCa8 = datas;
    notifyListeners();
  }
  Future<void> getProWantCa8(int userIdx, int page, int category) async {
    print("나의 활동 빌려주세요");
    this.proWantCa8 = [];
    final res = await productSv.getProRent(userIdx, page, category, "WANT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proWantCa8 = datas;
    notifyListeners();
  }

  //카테고리 9 서버데이터
  Future<void> getProRentCa9(int userIdx, int page, int category) async {
    print("나의 활동 빌려드려요.");
    this.proRentCa9 = [];
    final res = await productSv.getProRent(userIdx, page, category, "RENT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proRentCa9 = datas;
    notifyListeners();
  }
  Future<void> getProWantCa9(int userIdx, int page, int category) async {
    print("나의 활동 빌려주세요");
    this.proWantCa9 = [];
    final res = await productSv.getProRent(userIdx, page, category, "WANT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proWantCa9 = datas;
    notifyListeners();
  }

  //카테고리 10 서버데이터
  Future<void> getProRentCa10(int userIdx, int page, int category) async {
    print("나의 활동 빌려드려요.");
    this.proRentCa10 = [];
    final res = await productSv.getProRent(userIdx, page, category, "RENT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proRentCa10 = datas;
    notifyListeners();
  }
  Future<void> getProWantCa10(int userIdx, int page, int category) async {
    print("나의 활동 빌려주세요");
    this.proWantCa10 = [];
    final res = await productSv.getProRent(userIdx, page, category, "WANT");
    Map<String, dynamic> jsonMap = jsonDecode(res.toString());
    List<ProductMyActRent> datas = (jsonMap['data'] as List)
        .map((e) => ProductMyActRent.fromJson(e))
        .toList();
    this.proWantCa10 = datas;
    notifyListeners();
  }

  //물건 상태 변경
  Future<void> rentStatus(String token, int idx) async {
    print('빌려드려요. 상태 변경');
    final rentStatusMap =
        await productSv.rentStatusModified(idx, token);
    Map<String, dynamic> jsonMap = json.decode(rentStatusMap.toString());
    print(jsonMap);
    notifyListeners();
  }

  Future<void> rentStatusModified(int arrayNum, String status, String category) async {
    print("물건 상태 변경");
    print(category);
    if(category == "전체"){
      if (status == "IMPOSSIBLE")
        this.proRent[arrayNum].status = "POSSIBLE";
      else
        this.proRent[arrayNum].status = "IMPOSSIBLE";
    }else if(category == "생활용품"){
      if (status == "IMPOSSIBLE")
        this.proRentCa1[arrayNum].status = "POSSIBLE";
      else
        this.proRentCa1[arrayNum].status = "IMPOSSIBLE";
    }else if(category == "여행"){
      if (status == "IMPOSSIBLE")
        this.proRentCa2[arrayNum].status = "POSSIBLE";
      else
        this.proRentCa2[arrayNum].status = "IMPOSSIBLE";
    }else if(category == "스포츠/레저"){
      if (status == "IMPOSSIBLE")
        this.proRentCa3[arrayNum].status = "POSSIBLE";
      else
        this.proRentCa3[arrayNum].status = "IMPOSSIBLE";
    }else if(category == "육아"){
      if (status == "IMPOSSIBLE")
        this.proRentCa4[arrayNum].status = "POSSIBLE";
      else
        this.proRentCa4[arrayNum].status = "IMPOSSIBLE";
    }else if(category == "반려동물"){
      if (status == "IMPOSSIBLE")
        this.proRentCa5[arrayNum].status = "POSSIBLE";
      else
        this.proRentCa5[arrayNum].status = "IMPOSSIBLE";
    }else if(category == "가전제품"){
      if (status == "IMPOSSIBLE")
        this.proRentCa6[arrayNum].status = "POSSIBLE";
      else
        this.proRentCa6[arrayNum].status = "IMPOSSIBLE";
    }else if(category == "의류/잡화"){
      if (status == "IMPOSSIBLE")
        this.proRentCa7[arrayNum].status = "POSSIBLE";
      else
        this.proRentCa7[arrayNum].status = "IMPOSSIBLE";
    }else if(category == "가구/인테리어"){
      if (status == "IMPOSSIBLE")
        this.proRentCa8[arrayNum].status = "POSSIBLE";
      else
        this.proRentCa8[arrayNum].status = "IMPOSSIBLE";
    }else if(category== "자동차용품"){
      if (status == "IMPOSSIBLE")
        this.proRentCa9[arrayNum].status = "POSSIBLE";
      else
        this.proRentCa9[arrayNum].status = "IMPOSSIBLE";
    }else if(category == "기타"){
      if (status == "IMPOSSIBLE")
        this.proRentCa10[arrayNum].status = "POSSIBLE";
      else
        this.proRentCa10[arrayNum].status = "IMPOSSIBLE";
    }
    notifyListeners();
  }
}
