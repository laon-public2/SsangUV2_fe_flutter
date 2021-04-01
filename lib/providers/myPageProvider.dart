import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_product_v2/model/productMyActRent.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/providers/userProvider.dart';

import 'package:share_product_v2/services/productService.dart';

class MyPageProvider extends ChangeNotifier {
  final ProductService productSv = ProductService();

  List<ProductMyActRent> proRent = [];
  List<ProductMyActRent> proWant = [];

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
    this.proRent = datas;
    notifyListeners();
  }

  Future<void> rentStatus(String token, int idx) async {
    print('빌려드려요. 상태 변경');
    final rentStatusMap =
        await productSv.rentStatusModified(idx, token);
    Map<String, dynamic> jsonMap = json.decode(rentStatusMap.toString());
    print(jsonMap);
    notifyListeners();
  }

  Future<void> rentStatusModified(int arrayNum, String status) async {
    print("물건 상태 변경");
    if (status == "IMPOSSIBLE")
      this.proRent[arrayNum].status = "POSSIBLE";
    else
      this.proRent[arrayNum].status = "IMPOSSIBLE";
    notifyListeners();
  }
}
