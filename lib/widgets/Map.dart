import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kopo/kopo.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/mapProvider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customDoneBtn.dart';

class GoogleMaps extends StatefulWidget {
  final String type;
  GoogleMaps(this.type);
  // const GoogleMaps({Key key}) : super(key: key);

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  SharedPreferences pref;
  static LatLng _initialPosition;
  LatLng _cameraPosition;

  Completer<GoogleMapController> _controller = Completer();

  List<Marker> _markers = <Marker>[];

  String address = "";

  @override
  void initState() {
    super.initState();

    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print('${placemark[0].name}');
    });
  }

  Future<void> goToMyPosition() async {
    final CameraPosition _myPosition = CameraPosition(
      target: _initialPosition,
      zoom: 15,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myPosition));
  }

  Future<void> goToMySearchPosition(String position) async {
    final CameraPosition _myPosition = CameraPosition(
      target: LatLng(double.parse(position.split(",")[0]),
          double.parse(position.split(",")[1])),
      zoom: 15,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myPosition));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      pref = await SharedPreferences.getInstance();
    });
    print("map build");
    return new Container(
        child: _initialPosition != null
            ? Stack(children: [
                GoogleMap(
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(_markers),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 15,
                  ),
                  onCameraMove: ((_position) =>
                      _cameraPosition = _position.target),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                search(),
                Center(
                  child: Image.asset(
                    "assets/map_pin.png",
                    width: 28,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: CustomDoneBtn(
                    text: "완료",
                    func: () async {
                      String address =
                          await Provider.of<MapProvider>(context, listen: false)
                              .getAddress(_cameraPosition.latitude,
                                  _cameraPosition.longitude);
                      print("address : $address");
                      await Provider.of<ProductProvider>(context, listen: false)
                          .changeAddress(this.widget.type, _cameraPosition.latitude, _cameraPosition.longitude, address);
                      Navigator.of(context).pop(true);
                    },
                  ),
                )
              ])
            : Stack(
                children: [
                  Loading(),
                  Center(
                    child: Padding(
                        padding: EdgeInsets.only(top: 96),
                        child: Text(
                          "지도와 사용자 위치를 불러오고 있습니다...\n처음 불러올 때는 최대 10초의 시간이 소요될 수 있습니다.",
                          textAlign: TextAlign.center,
                        )),
                  )
                ],
              ));
  }

  Widget search() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      height: 104,
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              KopoModel model =
                  await Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => Kopo(),
              ));

              String position =
                  await Provider.of<MapProvider>(context, listen: false)
                      .getPosition(model.address);
              print("맵 위치 $position");
              setState(() {
                address = "${model.address}";
              });

              goToMySearchPosition(position);
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
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {
              goToMyPosition();
            },
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xffDDDDDD))),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        "assets/icon/current.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                    Text(
                      "현위치로 주소 설정",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
