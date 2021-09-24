//빌려 드려요
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/pages/product/ProductDetail.dart';
import 'package:share_product_v2/pages/product/ProductDetailRent.dart';
import 'package:share_product_v2/pages/product/ProductDetailWant.dart';
import 'package:share_product_v2/widgets/categoryContainer.dart';

class WantItemMyAct extends StatelessWidget {
  final int idx;
  final String category;
  final String title;
  final String name;
  final String minPrice;
  final String maxPrice;
  final String startDate;
  final String endDate;
  final String picture;
  // final String lati;
  // final String longti;

  WantItemMyAct(
      {required this.idx,
      required this.category,
      required this.title,
      required this.name,
      required this.minPrice,
      required this.maxPrice,
      required this.startDate,
      required this.endDate,
      required this.picture
      // this.lati,
      // this.longti
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // color: Colors.white,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailWant(this.idx, this.category)),
        );
      },
      child: Container(
        width: double.infinity,
        height: 111.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  'http://115.91.73.66:15066/assets/images/product/${this.picture}',
                  height: 100.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 211.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryContainer(
                        category: this.category,
                      ),
                      // Text(
                      //   '${this.distance}km',
                      //   style: TextStyle(color: Color(0xff999999)),
                      // ), km나올거 대신 해서 혹시 몰라서 나둠. 쓰실분 쓰셈
                      Text(
                        '${this.startDate} ~ ${this.endDate}',
                        style: TextStyle(color: Color(0xff999999)),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 211.w,
                      ),
                      child: Text(
                        this.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xff333333),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(),
                  child: Text(
                    this.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xff999999),
                    ),
                  ),
                ),
                Text(
                  "${this.minPrice} ~ ${this.maxPrice} / 일",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Color(0xff333333),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
