import 'package:flutter/material.dart';
import 'package:share_product_v2/widgets/customAppBar%20copy.dart';
import 'package:share_product_v2/widgets/customAppBar.dart';
import 'package:share_product_v2/widgets/simpleMap.dart';

class DetailMapPage extends StatelessWidget {
  final String address;
  final double latitude;
  final double longitude;

  DetailMapPage({this.address, this.latitude, this.longitude});

  @override
  Widget build(BuildContext context) {
    print("lat : $latitude");
    print("long : $longitude");
    return Scaffold(
        appBar: CustomAppBar.appBarWithPrev("$address", 0.0, context),
        body: Container(
            child: SimpleGoogleMaps(
          latitude: latitude,
          longitude: longitude,
        )));
  }
}
