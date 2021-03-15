import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:share_product_v2/model/KaKaoAddress.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/utils/APIUtil.dart';

class MapService {
  Dio dio = new Dio();

  Future getAddress(double latitude, double longitude) async {
    dio.options.baseUrl =
        "https://dapi.kakao.com/v2/local/geo/coord2address.json";
    dio.options.headers['Authorization'] =
        "KakaoAK e16a6db6450d8beff5797463b7b2ff01";

    try {
      Response response =
          await dio.get("?x=$longitude&y=$latitude&input_coord=WGS84");

      Map<String, dynamic> jsonMap = json.decode(response.toString());

      print(jsonMap["documents"][0]["address"]["address_name"].toString());

      // List<KakaoAddressModel> datas = (jsonMap["documents"] as List).map((e) => KakaoAddressModel.fromJson(e)).toList();

      return jsonMap["documents"][0]["address"]["address_name"].toString();
    } catch (e) {
      print(e);
    }
  }

  Future getPosition(String query) async {
    dio.options.baseUrl = "https://dapi.kakao.com/v2/local/search/address.json";
    dio.options.headers['Authorization'] =
        "KakaoAK e16a6db6450d8beff5797463b7b2ff01";
    try {
      Response response = await dio.get("", queryParameters: {"query": query});

      Map<String, dynamic> jsonMap = json.decode(response.toString());

      print(
          "${jsonMap["documents"][0]["y"].toString()}, ${jsonMap["documents"][0]["x"].toString()}");

      return "${jsonMap["documents"][0]["y"].toString()},${jsonMap["documents"][0]["x"].toString()}";
    } catch (e) {
      print(e);
    }
  }
}
