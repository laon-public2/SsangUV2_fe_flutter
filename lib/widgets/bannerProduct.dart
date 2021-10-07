import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/bannerProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerItemProduct extends StatelessWidget {
  // const BannerItem({Key key}) : super(key: key);

  var isCategory = false;
  List<dynamic>product = [];

  BannerItemProduct(this.isCategory, this.product);

  @override
  Widget build(BuildContext context) {
        return Container(
          // color: Colors.red,
          child: CarouselSlider(
            options: CarouselOptions(
              height: 300,
              aspectRatio: 16 / 9,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: false,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1,
              onPageChanged: (index, reason) {},
            ),
            items: product
                .map((e) {
              return Builder(builder: (context) {
                return Container(
                  width: 360.w,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Image.network(
                    "http://115.91.73.66:15066/assets/images/product/${e.file}",
                    fit: BoxFit.cover,
                  ),
                );
              });
            }).toList(),
          ),
        );

  }

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
