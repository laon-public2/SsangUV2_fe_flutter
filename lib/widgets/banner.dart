import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/bannerProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerItem extends StatelessWidget {
  // const BannerItem({Key key}) : super(key: key);

  BannerController bannerController = Get.put(BannerController());

  var isCategory = false;

  BannerItem(this.isCategory);

  @override
  Widget build(BuildContext context) {
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
            items: (this.isCategory ? bannerController.categoryBanner : bannerController.banners).map((e) {
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
                    child: ExtendedImage.network(
                      "http://115.91.73.66:15066/assets/images/banner/${e.path}",
                      fit: BoxFit.cover,
                      cache: true,
                      borderRadius: BorderRadius.circular(5),
                      loadStateChanged: (ExtendedImageState state) {
                        switch(state.extendedImageLoadState) {
                          case LoadState.loading :
                            return Image.asset(
                              "assets/loadingIcon.gif",
                              fit: BoxFit.contain,
                            );
                            break;
                          case LoadState.completed :
                            break;
                          case LoadState.failed :
                            return GestureDetector(
                              child: Image.asset(
                                "assets/icon/icons8-cloud-refresh-96.png",
                                fit: BoxFit.contain,
                              ),
                              onTap: () {
                                state.reLoadImage();
                              },
                            );
                            break;
                        }
                      },
                    ),
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
