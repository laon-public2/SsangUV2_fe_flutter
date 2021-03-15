import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/models/ApiResponse.dart';
import 'package:share_product_v2/models/member.dart';
import 'package:share_product_v2/utils/APIUtil.dart';

class PushService {
  Dio dio = ApiUtils.instance.dio;

  Future<Response> pushTokenSave(String token) async {
    Response response =
        await dio.post("/push", queryParameters: {"token": token});
    print(response.data);
    return response;
  }
}
