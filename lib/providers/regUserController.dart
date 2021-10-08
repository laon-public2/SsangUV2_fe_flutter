import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_product_v2/model/RegUserPh.dart';
import 'package:share_product_v2/services/regUser.dart';

class RegUserController extends GetxController {
  final RegUserService regUserService = RegUserService();
  var phoneActive = false.obs;
  var phoneActiveFailed = false.obs;
  var regUserTruth = false.obs;
  var chkUserChk = false.obs;
  var phNum = "".obs;



  late RegUserPhModel regPh;

  void phoneAct(String phoneAct) async {
    print("phone인증 $phoneAct");
    this.phNum.value = phoneAct;
    Map<String, dynamic>? phoneActivation =
        await regUserService.phone_act(phoneAct);
    print('인증번호 상태 = ${phoneActivation!['message']}');
    
  }

  void backBtn() async {
    print("인증 안함");
    this.phoneActive.value = false;
    this.phNum.value = "";
    
  }

  Future<void> phoneActCon(String phoneAct, String verify) async {
    print("phone인증");
    print('$phoneAct, $verify');
    Map<String, dynamic>? phoneActivation = await regUserService.phone_actCon(phoneAct, verify);
    print(phoneActivation.toString());
    print('인증번호 상태 = ${phoneActivation!['message']}');
    if (phoneActivation['message'] == "인증번호 검증 성공") {
      phoneActive.value = true;
      this.phNum.value = phoneAct;
    } else {
      phoneActive.value = false;
      phoneActiveFailed.value = true;
    }
    
  }

  Future<void> regUserForm(String password, String name, String userType,
      String push, String comNum, File? image, String fcmToken) async {
    print('유저 회원가입');
    print('$password, $name, $userType, $push, $comNum');
    if(userType == "BUSINESS"){
      print("업체 유저 회원가입");
      Map<String, dynamic>? regUser = await regUserService.RegUser(
          phNum.value, password, name, userType, push, comNum, image!, fcmToken);
      print(regUser.toString());
      if (regUser != null) {
        if (regUser['message'] == "회원가입에 성공하였습니다") {
          regUserTruth.value = true;
        }
      }
    }else{
      print("일반 유저 회원가입");
      Map<String, dynamic>? regUser = await regUserService.RegUserNormal(
          phNum.value, password, name, userType, push, fcmToken);
      print(regUser.toString());
      if (regUser != null) {
        if (regUser['message'] == "회원가입에 성공하였습니다") {
          regUserTruth.value = true;
        }
      }
    }
    // print('회원가입상태 = ${regUser['message']}');
    
  }

  Future<void> regUserChk(String phnum) async {
    print('유저체크');
    print('$phnum');
    Map<String, dynamic>? chkUser = await regUserService.user_chk(phnum);
    print('유저체크 상태 === ${chkUser!['success']}');
    if (chkUser['success']) {
      chkUserChk.value = true;
    } else {
      chkUserChk.value = false;
    }
  }
}
