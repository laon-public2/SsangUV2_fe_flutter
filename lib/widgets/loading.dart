import 'dart:math';

import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final List<String> randomCategory = [
    "assets/icon/category/household.png",
    "assets/icon/category/trip.png",
    "assets/icon/category/sport.png",
    "assets/icon/category/parenting.png",
    "assets/icon/category/pet.png",
    "assets/icon/category/laundry.png",
    "assets/icon/category/shopping.png",
    "assets/icon/category/furniture.png",
    "assets/icon/category/car.png",
    "assets/icon/category/etc.png"
  ];

  int num1 = 0;
  bool _isDispose = false;
  _randomNum() async {
    bool infinite = false;
    Random random = Random();
    while (infinite == false) {
      await Future.delayed(Duration(milliseconds: 400), () {
        if(_isDispose == false){
          setState(() {
            num1 = random.nextInt(9);
          });
        }
      });
    }
  }

  void initState() {
    super.initState();
    _randomNum();
  }

  void dispose() {
    super.dispose();
    _isDispose = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _willPopCallback(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.2),
        child: Center(
          child: Image.asset(randomCategory[num1], width: 48.0, height: 48.0,),
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    return true;
  }
}