import 'dart:async';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
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

class UserController extends GetxController {
  final UserService userService = UserService();
  final PushService pushService = PushService();
  var isLoggenIn = false.obs;
  var userIdx = 0.obs;
  var userFBtoken = "".obs;
  var originalFBtoken = "".obs;
  var phNum = "".obs;
  var accessToken = "".obs;
  var userProfileImg = "".obs;
  var username = "".obs;
  var userNum = "".obs;
  var userType = "".obs;
  var comNum = "".obs;
  var comIdentity = "".obs;
  var address = "".obs;
  var addressDetail = "".obs;

  var userLocationLatitude = 0.0.obs;
  var userLocationLongitude = 0.0.obs;
  var defaultUserLocationLatitude = 37.4869535.obs;
  var defaultUserLocationLongitude = 126.8956429.obs;
  var userPush = false.obs;

  late Paging userNotice;
  var userNoticeList = <UserNoticeModel>[].obs;


  MemberWithContractCount? loginMember;
  bool isFirstLogin = false;

  Future<void> initialUserLocation() async {
    var currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    this.userLocationLatitude.value = currentPosition.latitude;
    this.userLocationLongitude.value = currentPosition.longitude;
  }

  Future<void> getAccessToken(String phone, String password) async {
    print('로그인하기');
    Map<String, dynamic>? accessToken =
    await userService.getAccessToken(phone, password);
    if (accessToken != null) {
      if (accessToken['success'] == true) {
        print('$accessToken');
        this.accessToken.value = accessToken['access_token'];
        this.userIdx.value = accessToken['data']['idx'];
        SharedPref()
            .save("access_token", accessToken['access_token'].toString());
        SharedPref()
            .save("refresh_token", accessToken['refresh_token'].toString());
        this.isLoggenIn.value = true;
        this.phNum.value = phone;
        await getMyInfo();
        print('로그인되었음');
      } else {
        this.isLoggenIn.value = false;
      }
    }
    update();
  }

  Future<void> getAccessTokenReg(String phone, String password) async {
    print('로그인하기');
    Map<String, dynamic>? accessToken =
    await userService.getAccessToken(phone, password);
    if (accessToken != null) {
      if (accessToken['success'] == true) {
        print('$accessToken');
        this.accessToken.value = accessToken['access_token'];
        this.userIdx.value = accessToken['data']['idx'];
        SharedPref()
            .save("access_token", accessToken['access_token'].toString());
        SharedPref()
            .save("refresh_token", accessToken['refresh_token'].toString());
        this.isLoggenIn.value = true;
        this.phNum.value = phone;
        print('로그인되었음');
      } else {
        this.isLoggenIn.value = false;
      }
    }
    update();
  }

  Future<void> AddFCMtoken(String token) async {
    print("FCM토근 등록 $token");
    this.originalFBtoken.value = token;
    update();
  }

  Future<void> changeAddress(String address, String addressDetail, num la,
      num lo) async {
    print("유저 주소 변경");
    final res = await userService.changeUserAddress(
        phNum.value, address, addressDetail, la, lo, accessToken.value);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    if (jsonMap['success'] == true) {
      this.address.value = address;
      this.addressDetail.value = addressDetail;
      this.userLocationLatitude.value = la.toDouble();
      this.userLocationLongitude.value = lo.toDouble();
    }
    update();
  }

  Future<void> changePush() async {
    this.userPush.value = !this.userPush.value;
    print('유저 알림 서비스 변경');
    print(this.userIdx);
    final res = await userService.changePushService(
        this.accessToken.value, this.userIdx.value);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);

    update();
  }

  void fBToken() async {
    print('FCM토큰');
    Map<String, dynamic>? fbToken = await userService.updateFBtoken(
        this.userIdx.value, this.originalFBtoken.value, this.accessToken.value);
    if (fbToken != null) {
      print('fcm토큰이 수정되었음');
    } else {
      print('토큰 값을 수정해주시기 바랍니다. 이것은 잘못된 오류 입니다.');
    }
    update();
  }

  Future<String> getMyInfo() async {
    print('내정보 확인하기');
    print("${this.accessToken} ${this.phNum}");
    Map<String, dynamic>? myinfo =
    await userService.myInfo(this.accessToken.value, this.phNum.value);
    if (myinfo != null) {
      if (myinfo['success'] == true) {
        print(myinfo);
        this.username.value = myinfo['data']['name'];
        this.userType.value = myinfo['data']['userType'];
        this.comNum.value = myinfo['data']['businessIdentifyNum'] ?? '';
        this.comIdentity.value = myinfo['data']['businessIdentifyFile'] ?? '';
        this.address.value = myinfo['data']['address'];
        this.addressDetail.value = myinfo['data']['addressDetail'];
        this.userProfileImg.value = myinfo['data']['image'] ?? '';
        print('user length' + this.userProfileImg.value.length.toString());
        this.userFBtoken.value = myinfo['data']['fcm_token'];
        if(myinfo['data']['push'] == null) {
          this.userPush.value = false;
        }
        if (myinfo['data']['push'] == 1) {
          this.userPush.value = true;
        } else {
          this.userPush.value = false;
        }
        if(myinfo['data']['user_location'] != null){
          this.userLocationLatitude.value = myinfo['data']['user_location']['x'];
        } else {
          var currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
          this.userLocationLatitude.value = currentPosition.latitude;
        }
        if(myinfo['data']['user_location'] != null){
          this.userLocationLongitude.value = myinfo['data']['user_location']['y'];
        } else {
          var currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
          this.userLocationLongitude.value = currentPosition.longitude;
        }

        print('x == ${this.userLocationLatitude.value} y == ${this.userLocationLongitude}');
        if (this.originalFBtoken == this.userFBtoken) {
          update();
          return 'success';
        } else {
          print("fcm토큰 수정");
          fBToken();
        }
        update();
        return 'success';
      }
      else {
        update();
        return 'fail';
      }
    } else {
      this.username.value = "정보없음";
      this.userType.value = "nomal";
      this.comNum.value = "00-000-00000";
      this.address.value = "서울시 은평구 갈현동";
      this.addressDetail.value = "한스빌 478-2";
      this.userLocationLatitude.value = 37;
      this.userLocationLongitude.value = 126;
      this.userProfileImg.value = "userImgNot";
      update();
      return 'none';
    }
  }

  Future<void> refreshToken(String refreshToken) async {
    print("refreshToken");
    Map<String, dynamic>? accessToken =
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
        this.isLoggenIn.value = false;
      }
    } else {
      this.isLoggenIn.value = false;
    }
    update();
  }

  Future<bool> phone(String phone) async {
    Map<String, dynamic>? returnMap = await userService.checkLogin(phone);
    if (returnMap!['statusCode'] == 200) {
      if (returnMap['data'] != null) {
        isFirstLogin = true;
        setAccessToken(returnMap['data']['access_token']);
        SharedPref()
            .save("access_token", returnMap['data']['access_token'].toString());
        SharedPref().save(
            "refresh_token", returnMap['data']['refresh_token'].toString());
        this.isLoggenIn.value = true;
        update();
      }
    }
    return isFirstLogin;
    // update();
  }

  void me() async {
    ApiResponse apiResponse = await userService.me();
    loginMember = apiResponse.data;
    this.isLoggenIn.value = true;
    update();
  }

  Future setAccessToken(String token) async {
    print("accessToken with myInfo");
    Map<String, dynamic>? accessToken = await userService.set_token(token);
    if (accessToken != null) {
      if (accessToken['success'] == true) {
        this.isLoggenIn.value = true;
        this.accessToken.value = token;
        this.phNum.value = accessToken['data']['username'];
        this.userIdx.value = accessToken['data']['idx'];
        this.originalFBtoken.value = accessToken['data']['fcm_token'];
        await getMyInfo();
        if (this.originalFBtoken.value == this.userFBtoken.value) {
          return;
        } else {
          print("fcm토큰 수정");
          fBToken();
        }
      }
    } else {
      this.isLoggenIn.value = false;
    }
    update();
  }

  void logout() async {
    isLoggenIn.value = false;
    loginMember = null;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("access_token");
    pref.remove("refresh_token");
    update();
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
    final res = await userService.delete_user(userPh, accessToken.value);
    print(res.toString());
    this.isLoggenIn.value = false;
    update();
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
          userIdx.value, page, accessToken.value);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
      List<UserNoticeModel> list = (jsonMap['data'] as List)
          .map((e) => UserNoticeModel.fromJson(e)).toList();
      Paging paging = Paging.fromJson(jsonMap);
      this.userNotice = paging;
      if (this.userNotice.currentPage == null ||
          this.userNotice.currentPage == 0) {
        this.userNoticeList.value = list;
      } else {
        for (var e in list) {
          this.userNoticeList.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> userComChange(File images) async {
    print("대여업체 유저 사업자등록증 사진변경");
    final res = await userService.changeCompanyImg(images, this.accessToken.value, this.userIdx.value);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);
    await getMyInfo();
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
        fileList, this.accessToken.value, this.userIdx.value, this.username.value);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);
    await getMyInfo();
  }

  Future<String?> userInfoChange(String name) async {
    try {
      print("유저 이름 변경");
      final res = await userService.changeUserName(name, phNum.value, accessToken.value);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
      this.username.value = name;
      return jsonMap['success'];
    } catch (e) {
      print(e);
    }
    update();
  }

  Future<String?> userChangePwd(String currentPwd, String newPwd) async {
    try{
      print("유저 비밀번호 변경");
      final res = await userService.changePassword(this.phNum.value, currentPwd, newPwd, accessToken.value);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
      return jsonMap['success'];
    }catch(e){
      print(e);
    }
  }
}

