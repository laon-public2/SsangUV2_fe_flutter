import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:share_product_v2/model/ProductDetailWant.dart';

class ImageView extends StatelessWidget {
  List<dynamic> allPath = [];
  // final ProductFile path;
  final carouselController = new CarouselController();

  ImageView(this.allPath);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.white)
    );
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: (e) {
          Navigator.of(context).pop();
        },
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Hero(
            tag: "image",
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
                  "http://115.91.73.66:15066/assets/images/product/${e.path}",
                  fit: BoxFit.contain,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
