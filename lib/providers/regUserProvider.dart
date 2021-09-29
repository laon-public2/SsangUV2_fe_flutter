import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_product_v2/model/RegUserPh.dart';
import 'package:share_product_v2/services/regUser.dart';

class RegUserProvider with ChangeNotifier {
  final RegUserService regUserService = RegUserService();
  bool phoneActive = false;
  bool phoneActiveFailed = false;
  bool regUserTruth = false;
  bool chkUserChk = false;
  String? phNum;



  late RegUserPhModel regPh;

  void phoneAct(String phoneAct) async {
    print("phone인증 $phoneAct");
    this.phNum = phoneAct;
    Map<String, dynamic>? phoneActivation =
        await regUserService.phone_act(phoneAct);
    print('인증번호 상태 = ${phoneActivation!['message']}');
    notifyListeners();
  }

  void backBtn() async {
    print("인증 안함");
    this.phoneActive = false;
    this.phNum = "";
    notifyListeners();
  }

  Future<void> phoneActCon(String phoneAct, String verify) async {
    print("phone인증");
    print('$phoneAct, $verify');
    Map<String, dynamic>? phoneActivation = await regUserService.phone_actCon(phoneAct, verify);
    print(phoneActivation.toString());
    print('인증번호 상태 = ${phoneActivation!['message']}');
    if (phoneActivation['message'] == "인증번호 검증 성공") {
      phoneActive = true;
      this.phNum = phoneAct;
    } else {
      phoneActive = false;
      phoneActiveFailed = true;
    }
    notifyListeners();
  }

  Future<void> regUserForm(String password, String name, String userType,
      String push, String comNum, File? image, String fcmToken) async {
    print('유저 회원가입');
    print('$password, $name, $userType, $push, $comNum');
    if(userType == "BUSINESS"){
      print("업체 유저 회원가입");
      Map<String, dynamic>? regUser = await regUserService.RegUser(
          phNum!, password, name, userType, push, comNum, image!, fcmToken);
      print(regUser.toString());
      if (regUser != null) {
        if (regUser['message'] == "회원가입에 성공하였습니다") {
          regUserTruth = true;
        }
      }
    }else{
      print("일반 유저 회원가입");
      Map<String, dynamic>? regUser = await regUserService.RegUserNormal(
          phNum!, password, name, userType, push, fcmToken);
      print(regUser.toString());
      if (regUser != null) {
        if (regUser['message'] == "회원가입에 성공하였습니다") {
          regUserTruth = true;
        }
      }
    }
    // print('회원가입상태 = ${regUser['message']}');
    notifyListeners();
  }

  Future<void> regUserChk(String phnum) async {
    print('유저체크');
    print('$phnum');
    Map<String, dynamic>? chkUser = await regUserService.user_chk(phnum);
    print('유저체크 상태 === ${chkUser!['success']}');
    if (chkUser['success']) {
      chkUserChk = true;
    } else {
      chkUserChk = false;
    }
  }
}
