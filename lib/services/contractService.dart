import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:share_product_v2/model/product.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/utils/APIUtil.dart';

class ContractService {
  Dio dio = ApiUtils.instance.dio;
  Dio chatDio = ChatUtils.instance.dio;

  Future<ApiResponse> contract(int productIdx) async {
    Response response =
        await dio.post("/contracts", data: {"product": productIdx});

    ApiResponse apiResponse = ApiResponse<String>.fromJson(response.data);

    return apiResponse;
  }

  Future<Response> getContracts(int page) async {
    Response response = await dio.get("/contracts/chat", queryParameters: {
      "page": page,
    });

    return response;
  }

  Future<Response> getChatHistory(String uuid, int page) async {
    print("uuid : $uuid");
    print("page : $page");
    try {
      Response response = await chatDio.get(
        "/chat/list/$uuid",
        queryParameters: {
          "page": page,
        },
      );
      return response;
    } on DioError catch (e) {
      print("챗 기록 접속 에러");
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> contractUUID(String uuid) async {
    Response response = await dio.get("/contracts/${uuid}");

    return response;
  }

  Future<Response> contractWrite(String uuid, Map<String, dynamic> data) async {
    Response response = await dio.put("/contracts/${uuid}", data: data);
    return response;
  }

  Future<Response> contractApproval(String uuid) async {
    Response response = await dio.patch("/contracts/${uuid}");
    return response;
  }

  //대여 해준 내역
  Future<Response> contractDo() async {
    Response response = await dio.get("/contracts/do");
    return response;
  }

  //대여 받은 내역
  Future<Response> contractReceive() async {
    Response response = await dio.get("/contracts/receive");
    return response;
  }
}
