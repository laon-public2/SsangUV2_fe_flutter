import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:share_product_v2/model/banner.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/utils/APIUtil.dart';

class BannerService {
  Dio dio = ApiUtils.instance.dio;

  Future<List> getBanners() async {
    ApiResponse defaultJson;
    try {
      // final bannerTypeString = bannerType.toShortString();

      print("배너 서비스 접속");

      Response response = await dio.get(
        "/banner",
        // queryParameters: {"bannerType": bannerTypeString},
      );
      // print(json.decode(response.toString()));
      print('banner서비스 접속 상태 === ${response.statusCode}');
      Map<String, dynamic> jsonMap = json.decode(response.toString());
      // print(jsonMap['data']);

      List<BannerModel> datas = (jsonMap['data'] as List)
          .map((e) => BannerModel.fromJson(e))
          .toList();
      // print(datas);
      jsonMap['data'] = datas;

      defaultJson = ApiResponse<List<BannerModel>>.fromJson(jsonMap);
      // print(defaultJson);
    } on DioError catch (e) {
      print('배너 서비스 접속 에러');
      print(e.response.statusCode);
      print(e.response.data.toString());
      print(e.message);
    }

    return defaultJson.data;
  }
}
