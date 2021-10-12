import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:share_product_v2/model/StompSendDTO.dart';
import 'package:share_product_v2/model/contract.dart';
import 'package:share_product_v2/model/paging.dart';
import 'package:share_product_v2/model/product.dart';
import 'package:share_product_v2/model/specialProduct.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/pages/chat/chatting.dart';
import 'package:share_product_v2/services/chatService.dart';
import 'package:share_product_v2/services/contractService.dart';

class ContractController extends GetxController {
  final ContractService contractService = ContractService();

  final ChattingService chatService = ChattingService();

  var contracts = <ContractModel>[].obs;

  var contractsDo = <ContractModel>[].obs;
  var contractsReceive = <ContractModel>[].obs;
  var chatHistories = <StompSendDTO>[].obs;
  late Paging chatHistoriesCounter;

  late ContractModel contractModel;

  late Paging paging;


  Future<void> getChatHistory(String uuid, int page) async {
    print("채팅 서비스 프로바이더");
    if (page == 0) {
      this.chatHistories.clear();
    }
    final res = await contractService.getChatHistory(uuid, page);
    Map<String, dynamic> json = jsonDecode(res.toString());
    // print(json);
    try {
      List<StompSendDTO> list = (json['data'] as List)
          .map((e) => StompSendDTO.fromJson(e))
          .toList();

      Paging paging = Paging.fromJson(json);
      this.chatHistoriesCounter = paging;
      if (chatHistoriesCounter.currentPage == null || chatHistoriesCounter.currentPage == 0) {
        this.chatHistories.value = list;
      } else {
        for(var e in list){
          this.chatHistories.add(e);
        }
      }
      update();
    } catch (e) {
      print(e);
    }
  }


  Future<void> uploadImage(List<Asset> imgFile, String uuid, String sender) async {
    print("채팅방 이미지 업로드 부분");
    final res = await contractService.sendImgFile(imgFile, uuid, sender);
    print(res.toString());
  }

  Future<void> addChat(StompSendDTO dto) async {
    this.chatHistories.insert(0, dto);
    update();
  }

  Future<void> sendFcm(String title, String body, int productIdx, String uuid, int category, String productOwner, int price, String status, int receiverIdx, String token, String pic, String senderFcm, String receiverFcm, int senderIdx) async {
    print("fcm알림 프로바이더");
    final res = await contractService.sendFcmContent(
      title,
      body,
      productIdx,
      uuid,
      category,
      productOwner,
      price,
      status,
      receiverIdx,
      token,
      pic,
      senderFcm,
      receiverFcm,
      senderIdx,
    );
  }
}

// class ContractController extends GetxController {
//   final ContractService contractService = ContractService();
//
//   final ChattingService chatService = ChattingService();
//
//   var contracts = <ContractModel>[].obs;
//
//   var contractsDo = <ContractModel>[].obs;
//   var contractsReceive = <ContractModel>[].obs;
//   var chatHistories = <StompSendDTO>[].obs;
//   late Paging chatHistoriesCounter;
//
//   late ContractModel contractModel;
//
//   late Paging paging;
//
//
//   Future<void> getChatHistory(String uuid, int page) async {
//     print("채팅 서비스 프로바이더");
//     if (page == 0) {
//       this.chatHistories.clear();
//     }
//     final res = await contractService.getChatHistory(uuid, page);
//     Map<String, dynamic> json = jsonDecode(res.toString());
//     // print(json);
//     try {
//       List<StompSendDTO> list = (json['data'] as List)
//           .map((e) => StompSendDTO.fromJson(e))
//           .toList();
//
//       Paging paging = Paging.fromJson(json);
//       this.chatHistoriesCounter = paging;
//       if (chatHistoriesCounter.currentPage == null || chatHistoriesCounter.currentPage == 0) {
//         this.chatHistories.value = list;
//       } else {
//         for(var e in list){
//           this.chatHistories.add(e);
//         }
//       }
//       update();
//     } catch (e) {
//       print(e);
//     }
//   }
//
//
//   Future<void> uploadImage(List<Asset> imgFile, String uuid, String sender) async {
//     print("채팅방 이미지 업로드 부분");
//     final res = await contractService.sendImgFile(imgFile, uuid, sender);
//     print(res.toString());
//     update();
//   }
//
//   Future<void> addChat(StompSendDTO dto) async {
//     this.chatHistories.insert(0, dto);
//     update();
//   }
//
//   Future<void> sendFcm(String title, String body, int productIdx, String uuid, int category, String productOwner, int price, String status, int receiverIdx, String token, String pic, String senderFcm, String receiverFcm, int senderIdx) async {
//     print("fcm알림 프로바이더");
//     final res = await contractService.sendFcmContent(
//       title,
//       body,
//       productIdx,
//       uuid,
//       category,
//       productOwner,
//       price,
//       status,
//       receiverIdx,
//       token,
//       pic,
//       senderFcm,
//       receiverFcm,
//       senderIdx,
//     );
//     update();
//   }
// }
//
