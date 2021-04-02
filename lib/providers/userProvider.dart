import 'dart:async';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:share_product_v2/model/UserNoticeModel.dart';
import 'package:share_product_v2/model/paging.dart';
import 'package:share_product_v2/models/ApiResponse.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/models/member.dart';
import 'package:share_product_v2/services/pushService.dart';
import 'package:share_product_v2/services/userService.dart';
import 'package:share_product_v2/utils/APIUtil.dart';
import 'package:share_product_v2/utils/SharedPref.dart';
import 'package:share_product_v2/utils/pushMsg.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final UserService userService = UserService();
  final PushService pushService = PushService();
  bool isLoggenIn = false;
  int userIdx;
  String userFBtoken;
  String originalFBtoken;
  String phNum;
  String accessToken;
  String userProfileImg;
  String username;
  String userNum;
  String userType;
  String comNum;
  String comIdentity;
  String address;
  String addressDetail;
  double userLocationX;
  double userLocationY;
  bool userPush;

  Paging userNotice;
  List<UserNoticeModel> userNoticeList = [];

  MemberWithContractCount loginMember;
  bool isFirstLogin = false;

  Future<void> getAccessToken(String phone, String password) async {
    print('로그인하기');
    Map<String, dynamic> accessToken =
    await userService.getAccessToken(phone, password);
    if (accessToken != null) {
      if (accessToken['success'] == true) {
        print('$accessToken');
        this.accessToken = accessToken['access_token'];
        this.userIdx = accessToken['data']['idx'];
        SharedPref()
            .save("access_token", accessToken['access_token'].toString());
        SharedPref()
            .save("refresh_token", accessToken['refresh_token'].toString());
        this.isLoggenIn = true;
        this.phNum = phone;
        await getMyInfo();
        print('로그인되었음');
      } else {
        this.isLoggenIn = false;
      }
    }
    notifyListeners();
  }

  Future<void> getAccessTokenReg(String phone, String password) async {
    print('로그인하기');
    Map<String, dynamic> accessToken =
    await userService.getAccessToken(phone, password);
    if (accessToken != null) {
      if (accessToken['success'] == true) {
        print('$accessToken');
        this.accessToken = accessToken['access_token'];
        this.userIdx = accessToken['data']['idx'];
        SharedPref()
            .save("access_token", accessToken['access_token'].toString());
        SharedPref()
            .save("refresh_token", accessToken['refresh_token'].toString());
        this.isLoggenIn = true;
        this.phNum = phone;
        print('로그인되었음');
      } else {
        this.isLoggenIn = false;
      }
    }
    notifyListeners();
  }

  Future<void> AddFCMtoken(String token) async {
    print("FCM토근 등록 $token");
    this.originalFBtoken = token;
    notifyListeners();
  }

  Future<void> changeAddress(String address, String addressDetail, num la,
      num lo) async {
    print("유저 주소 변경");
    final res = await userService.changeUserAddress(
        phNum, address, addressDetail, la, lo, accessToken);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    if (jsonMap['success'] == true) {
      this.address = address;
      this.addressDetail = addressDetail;
      this.userLocationY = la;
      this.userLocationX = lo;
    }
    notifyListeners();
  }

  Future<void> changePush() async {
    this.userPush = !this.userPush;
    print('유저 알림 서비스 변경');
    print(this.userIdx);
    final res = await userService.changePushService(
        this.accessToken, this.userIdx);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);

    notifyListeners();
  }

  void fBToken() async {
    print('FCM토큰');
    Map<String, dynamic> fbToken = await userService.updateFBtoken(
        this.userIdx, this.originalFBtoken, this.accessToken);
    if (fbToken != null) {
      print('fcm토큰이 수정되었음');
    } else {
      print('토큰 값을 수정해주시기 바랍니다. 이것은 잘못된 오류 입니다.');
    }
    notifyListeners();
  }

  Future<void> getMyInfo() async {
    print('내정보 확인하기');
    print("${this.accessToken} ${this.phNum}");
    Map<String, dynamic> myinfo =
    await userService.myInfo(this.accessToken, this.phNum);
    if (myinfo != null) {
      if (myinfo['success'] == true) {
        print(myinfo);
        this.username = myinfo['data']['name'];
        this.userType = myinfo['data']['userType'];
        this.comNum = myinfo['data']['businessIdentifyNum'];
        this.comIdentity = myinfo['data']['businessIdentifyFile'];
        this.address = myinfo['data']['address'];
        this.addressDetail = myinfo['data']['addressDetail'];
        this.userLocationX = myinfo['data']['user_location']['x'];
        this.userLocationY = myinfo['data']['user_location']['y'];
        this.userProfileImg = myinfo['data']['image'];
        this.userFBtoken = myinfo['data']['fcm_token'];
        if (myinfo['data']['push'] == 1) {
          this.userPush = true;
        } else {
          this.userPush = false;
        }
        print('x == ${this.userLocationX} y == ${this.userLocationY}');
      }
    } else {
      this.username = "정보없음";
      this.userType = "nomal";
      this.comNum = "00-000-00000";
      this.address = "서울시 은평구 갈현동";
      this.addressDetail = "한스빌 478-2";
      this.userLocationX = 37;
      this.userLocationY = 126;
      this.userProfileImg = "userImgNot";
    }
    notifyListeners();
  }

  Future<void> refreshToken(String refreshToken) async {
    print("refreshToken");
    Map<String, dynamic> accessToken =
    await userService.refresh_token(refreshToken);
    print('$accessToken');
    if (accessToken != null) {
      if (accessToken['success'] == true) {
        SharedPref()
            .save("access_token", accessToken['access_token'].toString());
        SharedPref()
            .save("refresh_token", accessToken['refresh_token'].toString());
        SharedPreferences w = await SharedPreferences.getInstance();
      } else {
        this.isLoggenIn = false;
      }
    } else {
      this.isLoggenIn = false;
    }
    notifyListeners();
  }

  Future<bool> phone(String phone) async {
    Map<String, dynamic> returnMap = await userService.checkLogin(phone);
    if (returnMap['statusCode'] == 200) {
      if (returnMap['data'] != null) {
        isFirstLogin = true;
        setAccessToken(returnMap['data']['access_token']);
        SharedPref()
            .save("access_token", returnMap['data']['access_token'].toString());
        SharedPref().save(
            "refresh_token", returnMap['data']['refresh_token'].toString());
        this.isLoggenIn = true;
        notifyListeners();
      }
    }
    return isFirstLogin;
    // notifyListeners();
  }

  void me() async {
    ApiResponse apiResponse = await userService.me();
    loginMember = apiResponse.data;
    this.isLoggenIn = true;
    notifyListeners();
  }

  Future setAccessToken(String token) async {
    print("accessToken with myInfo");
    Map<String, dynamic> accessToken = await userService.set_token(token);
    if (accessToken != null) {
      if (accessToken['success'] == true) {
        this.isLoggenIn = true;
        this.accessToken = token;
        this.phNum = accessToken['data']['username'];
        this.userIdx = accessToken['data']['idx'];
        this.originalFBtoken = accessToken['data']['fcm_token'];
        await getMyInfo();
        if (this.originalFBtoken == this.userFBtoken) {
          return;
        } else {
          fBToken();
        }
      }
    } else {
      this.isLoggenIn = false;
    }
    notifyListeners();
  }

  void logout() async {
    isLoggenIn = false;
    loginMember = null;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("access_token");
    pref.remove("refresh_token");
    notifyListeners();
  }

  void setAddress(context, String address, String detail) async {
    ApiResponse apiResponse = await userService.setAddress(address, detail);
    print(apiResponse.data);
    if (apiResponse.statusCode == 200) {
      print("success");
      this.me();
    }
  }

  Future<void> DeleteUser(String userPh) async {
    final res = await userService.delete_user(userPh, accessToken);
    print(res.toString());
    this.isLoggenIn = false;
    notifyListeners();
  }

  Future<void> withdrawal() async {
    final res = await userService.withdrawal();
    print(res);
    Map<String, dynamic> responseJson = json.decode(res.toString());
    if (responseJson['statusCode'] == 200) {
      logout();
    }
    return;
  }

  Future<void> noticeView(int page) async {
    print("알림 페이지 프로바이더");
    try {
      final res = await userService.noticeViewService(
          userIdx, page, accessToken);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
      List<UserNoticeModel> list = (jsonMap['data'] as List)
          .map((e) => UserNoticeModel.fromJson(e)).toList();
      Paging paging = Paging.fromJson(jsonMap);
      this.userNotice = paging;
      if (this.userNotice.currentPage == null ||
          this.userNotice.currentPage == 0) {
        this.userNoticeList = list;
      } else {
        for (var e in list) {
          this.userNoticeList.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> userImgChange(List<Asset> files) async {
    print("유저 사진 변경");
    List<MultipartFile> fileList = [];
    var formData = FormData.fromMap({});
    for (var file in files) {
      ByteData byteData = await file.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      MultipartFile multipartFile =
      MultipartFile.fromBytes(imageData, filename: file.name);
      fileList.add(multipartFile);
      // MapEntry<String, MultipartFile> entry =
      // new MapEntry("files", multipartFile);
      // formData.files.add(entry);
    }
    final res = await userService.changeUserPic(
        fileList, this.accessToken, this.userIdx, this.username);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);
    await getMyInfo();
  }

  Future<String> userInfoChange(String name) async {
    try {
      print("유저 이름 변경");
      final res = await userService.changeUserName(name, phNum, accessToken);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
      await getMyInfo();
      return jsonMap['success'];
    } catch (e) {
      print(e);
    }
  }

  Future<String> userChangePwd(String currentPwd, String newPwd) async {
    try{
      print("유저 비밀번호 변경");
      final res = await userService.changePassword(this.phNum, currentPwd, newPwd, accessToken);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
      return jsonMap['success'];
    }catch(e){
      print(e);
    }
  }
}

