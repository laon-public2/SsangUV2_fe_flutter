import 'package:flutter/material.dart';
import 'package:share_product_v2/model/product.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageView extends StatelessWidget {
  final List<ProductFile> allPath;
  final ProductFile path;
  final carouselController = new CarouselController();

  ImageView({this.path, this.allPath});

  @override
  Widget build(BuildContext context) {
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
          color: Colors.white,
          child: Hero(
            tag: "image",
            child: CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                height: double.infinity,
                initialPage: allPath.indexOf(path),
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
              ),
              items: allPath.map((e) {
                return Image.network(
                  "http://ssangu.oig.kr:8080/resources?path=${e.path}",
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
