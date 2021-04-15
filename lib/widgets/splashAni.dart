import 'package:flutter/material.dart';
import 'dart:math';

class SplashAni extends StatefulWidget {
  @override
  _SplashAniState createState() => _SplashAniState();
}

class _SplashAniState extends State<SplashAni> {
  final List<String> RandomCategory = [
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
  int num2 = 1;
  int num3 = 2;
  int num4 = 3;
  int num5 = 4;
  bool _isDispose = false;

  _randomNum() async {
    bool infinite = false;
    Random random = Random();
    while (infinite == false) {
      await Future.delayed(Duration(milliseconds: 400), () {
        if(_isDispose == false){
          setState(() {
            num1 = random.nextInt(9);
            num2 = random.nextInt(9);
            num3 = random.nextInt(9);
            num4 = random.nextInt(9);
            num5 = random.nextInt(9);
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
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            child: Image.asset(
              RandomCategory[num1],
              width: 40,
              height: 40,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            child: Image.asset(
              RandomCategory[num2],
              width: 40,
              height: 40,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            child: Image.asset(
              RandomCategory[num3],
              width: 40,
              height: 40,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            child: Image.asset(
              RandomCategory[num4],
              width: 40,
              height: 40,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            child: Image.asset(
              RandomCategory[num5],
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}
