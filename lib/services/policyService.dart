import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:share_product_v2/model/policy.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/utils/APIUtil.dart';

class PolicyService {
  Dio dio = ApiUtils.instance.dio;

  Future<List> getPolicies() async {
    ApiResponse? defaultJson;
    try {
      Response response = await dio.get("/policy");

      Map<String, dynamic> jsonMap = json.decode(response.toString());

      List<PolicyModel> datas = (jsonMap['data'] as List)
          .map((e) => PolicyModel.fromJson(e))
          .toList();
      jsonMap['data'] = datas;

      defaultJson = ApiResponse<List<PolicyModel>>.fromJson(jsonMap);
    } catch (e) {
      print(e);
    }
    return defaultJson!.data;
  }

  // NOTICE: 안씁니당..~~!!!
  getPolicy(String title) async {
    ApiResponse? defaultJson;
    try {
      Response response = await dio.get("/policies/$title");

      Map<String, dynamic> jsonMap = json.decode(response.toString());

      defaultJson = ApiResponse<List<PolicyModel>>.fromJson(jsonMap);
    } catch (e) {
      print(e);
    }
    return defaultJson!.data;
  }
}
