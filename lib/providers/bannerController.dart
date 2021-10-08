import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_product_v2/model/banner.dart';
import 'package:share_product_v2/services/bannerService.dart';

// class BannerProvider extends ChangeNotifier {
//   final BannerService bannerService = BannerService();
//
//   List<BannerModel> banners = [];
//   List<BannerModel> categoryBanner = [];
//
//   Future<bool> getBanners() async {
//     print('배너 시작');
//     List<BannerModel> list = await bannerService.getBanners() as List<BannerModel>;
//     this.categoryBanner = list;
//     notifyListeners();
//     this.banners = list;
//     notifyListeners();
//     print(list.length);
//     if(list.length == 0){
//       return false;
//     }else return true;
//   }
// }

class BannerController extends GetxController {
  final BannerService bannerService = BannerService();

  List<BannerModel> banners = <BannerModel>[].obs;
  List<BannerModel> categoryBanner = <BannerModel>[].obs;

  Future<bool> getBanners() async {
    print('배너 시작');
    List<BannerModel> list = await bannerService.getBanners() as List<BannerModel>;
    this.categoryBanner = list;
    this.banners = list;
    print(list.length);
    if(list.length == 0){
      return false;
    }else return true;
  }

}
