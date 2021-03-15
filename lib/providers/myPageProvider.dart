import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_product_v2/model/productMyActRent.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/providers/userProvider.dart';

import 'package:share_product_v2/services/productService.dart';

class MyPageProvider extends ChangeNotifier {
  final ProductService productSv = ProductService();

  List<ProductMyActRent> proRent = [];

  Future<void> getProWant(int userIdx, int page, int category) async {
    print("나의 활동 빌려드려요.");
    this.proRent = null;
    List<ProductMyActRent> list =
        await productSv.getProRent(userIdx, page, category);
    this.proRent = list;
    print(this.proRent.toString());
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
