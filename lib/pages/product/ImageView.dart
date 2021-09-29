import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'dart:io';

class ImageView extends StatelessWidget {
  List<dynamic> allPath = [];

  // final ProductFile path;
  final carouselController = new CarouselController();

  ImageView(this.allPath);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: GestureDetector(
          onVerticalDragEnd: (e) {
            Navigator.of(context).pop();
          },
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  child: Hero(
                    tag: "ProductDetailImageView",
                    child: CarouselSlider(
                      carouselController: carouselController,
                      options: CarouselOptions(
                        height: double.infinity,
                        initialPage: 0,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: false,
                      ),
                      items: allPath.map((e) {
                        return Image.network(
                          "http://115.91.73.66:15066/assets/images/product/${e.file}",
                          fit: BoxFit.contain,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    width: double.infinity,
                    height: 80.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                        ],
                        stops: [
                          0.0,
                          1.9,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
