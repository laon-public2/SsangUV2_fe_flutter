//빌려 드려요
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/pages/product/ProductDetail.dart';
import 'package:share_product_v2/widgets/categoryContainer.dart';

class LendItem extends StatelessWidget {
  final String category;
  final String title;
  final String name;
  final String price;

  LendItem({this.category, this.title, this.name, this.price});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // color: Colors.white,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetail()),
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
                      Text(
                        '0.2km',
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
                  "${this.price} / 일",
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
