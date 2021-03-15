import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/models/ApiResponse.dart';
import 'package:share_product_v2/models/member.dart';
import 'package:share_product_v2/utils/APIUtil.dart';

class UserService {
  Dio dio = ApiUtils.instance.dio;
  // Dio Authdio = AuthUtils.instance.dio;

  Future<Response> noticeViewService(int userIdx, int page, String token) async {
    print("유저 알림 서비스 접속");
    print(userIdx);
    print(page);
    print(token);
    try{
      dio.options.headers['x-access-token'] = token;
      Response res = await dio.get(
        '/notice',
        queryParameters: {
          'userIdx' : "$userIdx",
          "page" : "$page",
        }
      );
      return res;
    }on DioError catch(e){
      print("유저 알림 서비스 접속 에러");
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> changePushService(String token, int userIdx) async{
    print('유저푸시 알림 서비스 변경');
    try{
      dio.options.headers['x-access-token'] = token;
      Response res = await dio.patch(
          '/user/pushupdate',
          data: {
            'userIdx' : userIdx,
          }
      );
      return res;
    }on DioError catch(e){
      print("유저 푸시 알림서비스 접속 에러");
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> changeUserAddress(String phNum, String address, String addressDetail, num la, num lo, String token) async {
    print('유저 주소 변경 서비스 접속');
    try{
      dio.options.headers['x-access-token'] = token;
      dio.options.contentType = "application/x-www-form-urlencoded";
      Response res = await dio.patch(
        '/user/changelocation',
        data: {
          "username": phNum,
          "address": address,
          'addressDetail': addressDetail,
          "latitude": la,
          "longitude": lo,
        }
      );
      return res;
    }on DioError catch(e){
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Map<String, dynamic>> getAccessToken(
      String phone, String password) async {
    try {
      print(phone);
      Response response = await dio
          .post("/user/login", data: {"username": phone, 'password': password});
      print("response = ${response.statusCode}");
      Map<String, dynamic> jsonMap;
      if (response.statusCode == 400) {
        return jsonMap;
      } else {
        return json.decode(response.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> refresh_token(String refresh_token) async {
    try {
      dio.options.contentType = 'application/x-www-form-urlencoded';
      Response response = await dio
          .post("/user/refresh", data: {"refresh_token": refresh_token});
      print("response리프레시 = ${response.statusCode}");
      Map<String, dynamic> jsonMap;
      if (response.statusCode == 400) {
        return jsonMap;
      } else {
        return json.decode(response.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Response> delete_user(String userPh, String access_token) async{
    try{
      dio.options.contentType = "application/x-www-form-urlencoded";
      dio.options.headers['x-access-token'] = access_token;
      Response response = await dio.delete(
        "/user/memberout",
        data: {
          "access_token" : access_token,
          "username" : userPh,
        },
      );
    }on DioError catch (e){
      print(e.response.statusCode);
    }
  }

  Future<Map<String, dynamic>> myInfo(String token, String phnum) async {
    try {
      print("내정보 확인 접속 서비스");
      print("$phnum");
      print(token);
      dio.options.contentType = 'application/x-www-form-urlencoded';
      dio.options.contentType = Headers.formUrlEncodedContentType;
      dio.options.headers['x-access-token'] = token;
      Response response = await dio.get(
        "/user/myinfo",
        queryParameters: {
          "username": phnum,
        },
      );
      print(response.data.toString());
      print("res내정보상태 = ${response.statusCode}");
      Map<String, dynamic> jsonMap;
      if (response.statusCode == 403) {
        return jsonMap;
      } else if (response.statusCode == 400) {
        return jsonMap;
      } else if (response.statusCode == 404) {
        return jsonMap;
      } else {
        return json.decode(response.toString());
      }
    } on DioError catch (e) {
      print(e.response.statusCode);
      print(e.response.headers);
      print(e.response.request);
      print(e.request);
      print(e.message);
      Map<String, dynamic> jsonMap;
      return jsonMap;
    }
  }

  Future<Map<String, dynamic>> set_token(String access_token) async {
    try {
      print("토큰값. 토큰 로그인 == $access_token");
      dio.options.headers['x-access-token'] = access_token;
      Response response = await dio.post("/user/login/token");
      print("response = ${response.statusCode}");
      Map<String, dynamic> jsonMap;
      if (response.statusCode == 400) {
        return jsonMap;
      } else {
        return json.decode(response.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> updateFBtoken(
      int userIDX, String fcmToken, String myToken) async {
    try {
      dio.options.contentType = "application/x-www-form-urlencoded";
      dio.options.headers['x-access-token'] = myToken;
      Response res = await dio.patch(
        '/user/tokenupdate',
        data: {
          'userIdx': userIDX,
          'fcmToken': fcmToken,
        },
      );
      print('fcm토큰 업뎃 === ${res.statusCode}');
      return json.decode(res.toString());
    } on DioError catch (e) {
      Map<String, dynamic> jsonMap;
      print(e.response.statusCode);
      if (e.response.statusCode == 403) {
        return jsonMap;
      }
      print(e.response.headers);
      print(e.response.request);
      print(e.request);
      print(e.message);
    }
  }

  Future<Map<String, dynamic>> myInfo_token(
      String access_token, String username) async {
    try {
      dio.options.contentType = "application/x-www-form-urlencoded";
      Response response = await dio.post(
        "/user/myinfo",
        data: {
          "access_token": access_token,
          "username": username,
        },
      );
      print("response = ${response.statusCode}");
      Map<String, dynamic> jsonMap;
      if (response.statusCode == 400) {
        return jsonMap;
      } else {
        return json.decode(response.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> checkLogin(String phone) async {
    try {
      Response response = await dio.post("/phone", data: {
        "phone": phone,
      });
      print("response = $response");
      Map<String, dynamic> jsonMap = json.decode(response.toString());

      return jsonMap;
    } catch (e) {
      print(e);
    }
  }

  Future<ApiResponse> me() async {
    try {
      Response response = await dio.get("/members/me");
      print("me ${response}");
      Map<String, dynamic> jsonMap = json.decode(response.toString());
      print('me jsonMap ${jsonMap['data']}');
      print(jsonMap['data'].runtimeType);
      MemberWithContractCount data =
          MemberWithContractCount.fromJson(jsonMap['data']);
      jsonMap['data'] = data;
      ApiResponse apiResponse =
          ApiResponse<MemberWithContractCount>.fromJson(jsonMap);

      return apiResponse;
    } on DioError catch (e) {
      print(e);
      ApiResponse apiResponse = new ApiResponse(
          statusCode: 500, message: e.message, data: e.response);
      return apiResponse;
    }
  }

  Future<ApiResponse> logout() async {
    try {
      Response response = await dio.get("/logout");

      Map<String, dynamic> jsonMap = json.decode(response.toString());
      ApiResponse apiResponse = ApiResponse.fromJson(jsonMap);

      return apiResponse;
    } on DioError catch (e) {
      ApiResponse apiResponse = new ApiResponse(
          statusCode: e.response.statusCode,
          message: e.message,
          data: e.response);
      return apiResponse;
    }
  }

  Future<Response> withdrawal() async {
    Response response = await dio.delete("/members");
    return response;
  }

  Future<ApiResponse> setAddress(String address, String detail) async {
    try {
      Response response = await dio
          .post("/members/address", data: {"address": address, "detail": ""});

      Map<String, dynamic> jsonMap = json.decode(response.toString());
      ApiResponse apiResponse = ApiResponse.fromJson(jsonMap);

      return apiResponse;
    } on DioError catch (e) {
      ApiResponse apiResponse = new ApiResponse(
          statusCode: e.response.statusCode,
          message: e.message,
          data: e.response);
      return apiResponse;
    }
  }

  Future<ApiResponse> test() async {
    try {
      Response response = await dio.get("/banners123");

      Map<String, dynamic> jsonMap = json.decode(response.toString());
      List<Banner> datas =
          (jsonMap['data'] as List).map((e) => Banner.fromJson(e)).toList();
      jsonMap['data'] = datas;
      ApiResponse apiResponse = ApiResponse<List<Banner>>.fromJson(jsonMap);

      return apiResponse;
    } on DioError catch (e) {
      ApiResponse apiResponse = new ApiResponse(
          statusCode: e.response.statusCode,
          message: e.message,
          data: e.response);
      return apiResponse;
    }
  }
}
