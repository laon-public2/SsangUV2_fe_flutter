//빌려 주세요
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/widgets/categoryContainer.dart';

class RentItem extends StatelessWidget {
  final String category;
  final String title;
  final String name;
  final String startPrice;
  final String endPrice;
  final String startDate;
  final String endDate;

  RentItem(
      {required this.category,
      required this.title,
      required this.name,
      required this.startPrice,
      required this.endPrice,
      required this.startDate,
      required this.endDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 105.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CategoryContainer(
                category: this.category,
              ),
              Spacer(),
              Text(
                "${startDate} ~ ${endDate}",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Color(0xff999999),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 6),
            child: Text(
              this.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xff333333),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              this.name,
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xff999999),
              ),
            ),
          ),
          Text(
            "${this.startPrice} ~ ${this.endPrice} / 일",
            style: TextStyle(
              fontSize: 16.sp,
              color: Color(0xff333333),
            ),
          ),
        ],
      ),
    );
  }
}
