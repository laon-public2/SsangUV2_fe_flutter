import 'package:flutter/material.dart';
import 'package:share_product_v2/model/KaKaoAddress.dart';
import 'package:share_product_v2/services/MapService.dart';

class MapProvider extends ChangeNotifier {
  final MapService mapService = MapService();

  // String kakaoAddress;
  // String KaKaoPosition;

  Future<String> getAddress(double latitude, double longitude) async {
    String data = await mapService.getAddress(latitude, longitude);
    // this.kakaoAddress = data;
    // notifyListeners();

    return data;
  }

  getPosition(String query) async {
    String data = await mapService.getPosition(query);

    // this.KaKaoPosition = data;
    // notifyListeners();

    return data;
  }
}
