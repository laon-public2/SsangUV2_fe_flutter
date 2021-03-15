import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kopo/kopo.dart';
import 'package:share_product_v2/widgets/Map.dart';
import 'package:share_product_v2/widgets/customAppBar%20copy.dart';
import 'package:share_product_v2/widgets/customAppBar.dart';
import 'package:share_product_v2/widgets/customDoneBtn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  Geolocator geolocator;

  String address = "";

  double latitude = 37.5666805;
  double longitude = 126.9784147;
  String type;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args = ModalRoute.of(context).settings.arguments;
    this.type = args["type"];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBarWithPrev("주소설정", 1.0, context),
      body: body(),
    );
  }

  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // search(),
        Expanded(
          child: Stack(
            children: [
              latitude != null ? Positioned.fill(child: map()) : Container(),
            ],
          ),
        )
      ],
    );
  }

  Widget search() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              KopoModel model =
                  await Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => Kopo(),
              ));

              print(model.toJson());

              setState(() {
                address = "${model.address}";
              });
            },
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Color(0xffDDDDDD))),
              height: 40,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Image.asset(
                      "assets/icon/search.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                  Text(address != "" ? address : "위치를 검색하실려면 눌러주세요."),
                  // Align(
                  //     alignment: FractionalOffset.centerLeft, child: Text("가산동")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget map() {
    print("map load");
    return Container(
      child: GoogleMaps(this.type),
    );
  }

  Widget fin() {
    return Container();
  }
}
