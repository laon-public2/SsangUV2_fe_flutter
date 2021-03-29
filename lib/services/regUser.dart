import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:share_product_v2/utils/APIUtil.dart';

class RegUserService {
  Dio dio = ApiUtils.instance.dio;

  Future<Map<String, dynamic>> phone_act(String phone_act) async {
    try {
      dio.options.contentType = 'application/x-www-form-urlencoded';
      Response response = await dio.post(
        "/user/postVerifyCode",
        data: {
          'phoneNumber': phone_act,
        },
      );
      Map<String, dynamic> jsonMap = json.decode(response.toString());
      return jsonMap;
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> phone_actCon(
      String phone_actCon, String verify) async {
    try {
      dio.options.contentType = 'application/x-www-form-urlencoded';
      Response response = await dio.post(
        "/user/confirmVerifyCode",
        data: {
          'phoneNumber': phone_actCon,
          'verifyCode': verify,
        },
      );
      Map<String, dynamic> jsonMap = json.decode(response.toString());
      return jsonMap;
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> user_chk(String phoneNumber) async {
    try {
      dio.options.contentType = "application/x-www-form-urlencoded";
      Response response = await dio.post(
        "/user/usercheck",
        data: {
          'username': phoneNumber,
        },
      );
      Map<String, dynamic> jsonMap = json.decode(response.toString());
      print(jsonMap);
      return jsonMap;
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> RegUser(
    String phoneNum,
    String password,
    String name,
    String userType,
    String push,
    String comNum,
    File image,
    String fcmToken,
  ) async {
    try {
      String fileName = image.path.split('/').last;
      print('$phoneNum, $password, $name, $userType, $push, $comNum');
      FormData data = FormData.fromMap({
        'username': phoneNum,
        'password': password,
        'name': name,
        'userType': userType,
        'push': push,
        'businessIdentifyNum': comNum,
        'businessIdentifyFile': await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
        "fcmToken" : fcmToken,
      });
      dio.options.contentType = 'application/x-www-form-urlencoded';
      Response response = await dio.post(
        "/user/join",
        data: data,
      );
      print("response ===== ${response.statusCode}");
      Map<String, dynamic> jsonMap;
      if (response.statusCode == 204) {
        return jsonMap;
      } else {
        return json.decode(response.toString());
      }

      // return jsonMap;
    } on DioError catch (e) {
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Map<String, dynamic>> RegUserNormal(
      String phoneNum,
      String password,
      String name,
      String userType,
      String push,
      String fcmToken
      ) async {
    try {
      print('$phoneNum, $password, $name, $userType, $push, $fcmToken');
      // FormData data = FormData.fromMap({
      //   'username': phoneNum,
      //   'password': password,
      //   'name': name,
      //   'userType': userType,
      //   'push': 0,
      //   "fcmToken" : fcmToken,
      // });
      dio.options.contentType = 'application/x-www-form-urlencoded';
      Response response = await dio.post(
        "/user/join",
        data: {
          'username': phoneNum,
          'password': password,
          'name': name,
          'userType': "NORMAL",
          'push': 0,
          "fcmToken" : fcmToken,
      }
      );
      print("response ===== ${response.statusCode}");
      Map<String, dynamic> jsonMap;
      if (response.statusCode == 204) {
        return jsonMap;
      } else {
        return json.decode(response.toString());
      }

      // return jsonMap;
    } on DioError catch (e) {
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }
}
