import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:share_product_v2/model/contract.dart';
import 'package:share_product_v2/model/paging.dart';
import 'package:share_product_v2/model/product.dart';
import 'package:share_product_v2/model/specialProduct.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/pages/chat/chatting.dart';
import 'package:share_product_v2/services/chatService.dart';
import 'package:share_product_v2/services/contractService.dart';

class ContractProvider extends ChangeNotifier {
  final ContractService contractService = ContractService();

  final ChattingService chatService = ChattingService();

  List<ContractModel> contracts = new List<ContractModel>();

  List<ContractModel> contractsDo = new List<ContractModel>();
  List<ContractModel> contractsReceive = new List<ContractModel>();
  List<StompSendDTO> chatHistories = new List<StompSendDTO>();

  ContractModel contractModel;

  Paging paging;

//   Future<void>(String uuid) async {
//     final res = await chatService.sendMsg(uuid);
// }

  getContracts(int page) async {
    final res = await contractService.getContracts(page);
    Map<String, dynamic> json = jsonDecode(res.toString());
    try {
      List<ContractModel> list = (json['data']['content'] as List)
          .map((e) => ContractModel.fromJson(e))
          .toList();
      this.contracts = list;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<String> contract(int id) async {
    ApiResponse res = await contractService.contract(id);
    return res.data.toString();
  }

  Future<String> contractUUID(String uuid) async {
    final res = await contractService.contractUUID(uuid);
    Map<String, dynamic> json = jsonDecode(res.toString());
    print('json : $json');
    ContractModel contractModel = ContractModel.fromJson(json['data']);
    this.contractModel = contractModel;
    notifyListeners();
  }

  Future<bool> contractWrite(
      String uuid, String startDate, String endDate) async {
    Map<String, dynamic> data = {
      "borrowedDate": startDate,
      "returnDate": endDate
    };

    final res = await contractService.contractWrite(uuid, data);
    Map<String, dynamic> json = jsonDecode(res.toString());
    print('json : $json');

    if (json['statusCode'] == 200) return true;

    return false;
  }

  Future<bool> contractaApproval(String uuid) async {
    final res = await contractService.contractApproval(uuid);
    Map<String, dynamic> json = jsonDecode(res.toString());
    print('json : $json');

    if (json['statusCode'] == 200) return true;

    return false;
  }

  void contractDo() async {
    final res = await contractService.contractDo();
    Map<String, dynamic> json = jsonDecode(res.toString());

    try {
      List<ContractModel> list =
          (json['data'] as List).map((e) => ContractModel.fromJson(e)).toList();
      this.contractsDo = list;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void contractReceive() async {
    final res = await contractService.contractReceive();
    Map<String, dynamic> json = jsonDecode(res.toString());
    try {
      List<ContractModel> list =
          (json['data'] as List).map((e) => ContractModel.fromJson(e)).toList();
      this.contractsReceive = list;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void getChatHistory(String uuid, int page) async {
    final res = await contractService.getChatHistory(uuid, page);
    print(res);
    Map<String, dynamic> json = jsonDecode(res.toString());

    if (page == 0) {
      this.chatHistories = [];
    }

    try {
      List<StompSendDTO> list = (json['content'] as List)
          .map((e) => StompSendDTO.fromJson(e))
          .toList();
      print(list);

      Paging paging = Paging.fromJson(json['paging']);
      this.paging = paging;

      if (paging.currentPage == null || paging.currentPage == 0) {
        this.chatHistories = list;
      } else {
        this.chatHistories.addAll(list);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void addChat(StompSendDTO dto) {
    this.chatHistories.insert(0, dto);
    notifyListeners();
  }
}
