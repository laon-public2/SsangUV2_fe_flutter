//빌려 드려요
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/pages/product/ProductDetail.dart';
import 'package:share_product_v2/pages/product/ProductDetailRent.dart';
import 'package:share_product_v2/widgets/categoryContainer.dart';

class reviewPage extends StatelessWidget {
  final String picture;
  final String nickname;
  final String createAt;
  final int grage;
  final String description;



  reviewPage({required this.picture, required this.nickname, required this.createAt, required this.grage, required this.description});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50.w,
        height: 50.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            "http://115.91.73.66:15066/assets/images/user/${this.picture}",
            height: 100.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),

      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                this.nickname,
                style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black
                ),
              ),
              SizedBox(width: 10),
              Text(
                "${this.createAt}",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Color(0xff999999),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                height: 13,
                width: 13,
                child: Image.asset('assets/icon/reviewStar.png'),
              ),
              Text(
                '$grage.0',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              )
            ],
          )
        ],
      ),
      subtitle: Text(
        this.description,
        style: TextStyle(
          fontSize: 13,
          color: Color(0xff666666),
        ),
      ),
    );
  }
}
