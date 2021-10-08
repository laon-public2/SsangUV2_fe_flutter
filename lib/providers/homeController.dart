import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:share_product_v2/pages/chat/CustomerMessage.dart';
import 'package:share_product_v2/providers/productController.dart';

class HomeController extends GetxController {

  ProductController productController = Get.find<ProductController>();
  var lati = 0.0.obs;
  var longti = 0.0.obs;
  var page = 0.obs;
  var currentItem = "".obs;
  var visible = 0.0.obs;

  final List<String> itemKind = [
    "빌려주세요",
    "빌려드려요",
    "도와주세요"
  ];

  ScrollController homeScroller = ScrollController();

  homeScrollerListener() async{
    final pvm = productController;
    if(homeScroller.position.pixels == homeScroller.position.maxScrollExtent){
      print("스크롤이 가장 아래입니다.");
      if(this.currentItem == "빌려드려요"){
        if(pvm.paging.totalCount != pvm.mainProducts.length){
          this.page++;
          productController.getMainRent(this.page.value);
          // Provider.of<ProductProvider>(context, listen: false)
          //     .getMainRent(this.page);
        }
      }else{
        if(pvm.paging.totalCount != pvm.mainProductsWant.length){
          this.page++;
          productController.getMainWant(this.page.value);
          // Provider.of<ProductProvider>(context, listen: false)
          //     .getMainWant(this.page);
        }
      }
    }
  }

  @override
  void onInit() {
    currentItem.value = itemKind.first;
    homeScroller.addListener(homeScrollerListener);
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('on resume $message');
      Platform.isIOS ?
      Get.to(CustomerMessage(
        message.data['uuid']!,
        int.parse(message.data['productIdx']),
        message.data['title'],
        message.data['category'],
        message.data['productOwner'],
        int.parse(message.data['price']),
        message.data['pic'],
        message.data['status'],
        int.parse(message.data['receiverIdx']),
        message.data['senderFcm'],
        message.data['receiverFcm'],
        int.parse(message.data['senderIdx']),
      )) :

      // Navigator.push(context, MaterialPageRoute(
      //     builder: (context) =>
      // )):
      Get.to(CustomerMessage(
        message.data['data']['uuid'],
        int.parse(message.data['data']['productIdx']),
        message.data['data']['title'],
        message.data['data']['category'],
        message.data['data']['productOwner'],
        int.parse(message.data['data']['price']),
        message.data['data']['pic'],
        message.data['data']['status'],
        int.parse(message.data['data']['receiverIdx']),
        message.data['data']['senderFcm'],
        message.data['data']['receiverFcm'],
        int.parse(message.data['data']['senderIdx']),
      ));
      // Navigator.push(context, MaterialPageRoute(
      //     builder: (context) =>
      // ));
    });

    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print('on message $message');
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print('on resume $message');
    //     Platform.isIOS ?
    //     Navigator.push(context, MaterialPageRoute(
    //         builder: (context) => CustomerMessage(
    //           message['uuid'],
    //           int.parse(message['productIdx']),
    //           message['title'],
    //           message['category'],
    //           message['productOwner'],
    //           int.parse(message['price']),
    //           message['pic'],
    //           message['status'],
    //           int.parse(message['receiverIdx']),
    //           message['senderFcm'],
    //           message['receiverFcm'],
    //           int.parse(message['senderIdx']),
    //         )
    //     )):
    //     Navigator.push(context, MaterialPageRoute(
    //         builder: (context) => CustomerMessage(
    //           message['data']['uuid'],
    //           int.parse(message['data']['productIdx']),
    //           message['data']['title'],
    //           message['data']['category'],
    //           message['data']['productOwner'],
    //           int.parse(message['data']['price']),
    //           message['data']['pic'],
    //           message['data']['status'],
    //           int.parse(message['data']['receiverIdx']),
    //           message['data']['senderFcm'],
    //           message['data']['receiverFcm'],
    //           int.parse(message['data']['senderIdx']),
    //         )
    //     ));
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print('on launch $message');
    //   },
    // );
    Future.delayed(Duration(milliseconds: 100), () {
      visible.value = 1.0;

      // setState(() {
      //   _visible = 1.0;
      // });
    });
    super.onInit();
  }

  @override
  void dispose() {
    homeScroller.dispose();
    super.dispose();
  }

}
