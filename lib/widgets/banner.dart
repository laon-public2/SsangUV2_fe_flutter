import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/bannerProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerItem extends StatelessWidget {
  // const BannerItem({Key key}) : super(key: key);

  var isCategory = false;

  BannerItem(this.isCategory);

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerProvider>(
      builder: (_, banner, __) {
        return Container(
          // color: Colors.red,
          child: CarouselSlider(
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1,
              onPageChanged: (index, reason) {},
            ),
            items: (this.isCategory ? banner.categoryBanner : banner.banners)
                .map((e) {
              return Builder(builder: (context) {
                return InkWell(
                  onTap: () {
                    _launchURL(e.url);
                  },
                  child: Container(
                    width: 360.w,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Image.network(
                      // "http://192.168.100.232:5050/assets/images/banner/${e.bannerFile}",
                      "http://192.168.100.232:5066/assets/images/banner/${e.bannerFile}",
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                        return Image.asset(
                          'assets/loadingIcon.gif',
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                );
              });
            }).toList(),
          ),
        );
      },
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
