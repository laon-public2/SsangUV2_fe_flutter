import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SimpleGoogleMaps extends StatefulWidget {
  final double latitude;
  final double longitude;


  const SimpleGoogleMaps({this.longitude, this.latitude});

  @override
  State<SimpleGoogleMaps> createState() => _SimpleGoogleMapsState();
}


class _SimpleGoogleMapsState extends State<SimpleGoogleMaps> {
  double latitude;
  double longitude;
  GoogleMapController mapController;

  List<Marker> _markers = <Marker>[];
  // CameraPosition cameraPosition;


  @override
  void initState() {
    super.initState();
    latitude = widget.latitude;
    longitude = widget.longitude;

    // print("init lat : $latitude, long : $longitude");
    // cameraPosition = CameraPosition(
    //   target:  LatLng(latitude, longitude),
    //   zoom: 15,
    // );

    // Marker marker;
    //
    // marker = Marker(
    //   markerId: MarkerId("main"),
    //   position: LatLng(latitude, longitude),
    // );
    //
    // _markers.add(marker);
  }

  @override
  Widget build(BuildContext context) {

    // setState(() {
    //   latitude = widget.latitude;
    //   longitude = widget.longitude;
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(widget.latitude, widget.longitude), zoom: 15 )
      );
      mapController.moveCamera(cameraUpdate);
    });

    print("map build");
    print("lat : $latitude, long : $longitude");
    CameraPosition cameraPosition = CameraPosition(
      target:  LatLng(widget.latitude, widget.longitude),
      zoom: 15,
    );
    setState(() {
      cameraPosition = CameraPosition(
        target:  LatLng(widget.latitude, widget.longitude),
        zoom: 15,
      );
    });

    Marker marker;

    marker = Marker(
      markerId: MarkerId("main"),
      position: LatLng(widget.latitude, widget.longitude),
    );

    _markers.add(marker);


    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: Set<Marker>.of(_markers),
        myLocationButtonEnabled: false,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        tiltGesturesEnabled: false,
        rotateGesturesEnabled: false,
        initialCameraPosition: cameraPosition,
        // onCameraMove: ((_position) => print(_position.target)),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}


