import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryItem extends StatelessWidget {
  final String assets;
  final String text;

  CategoryItem({this.assets, this.text});

  @override
  Widget build(BuildContext context) {
    // print(this.assets);
    return Container(
      width: 64.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 3.0),
            width: 36.0.w,
            height: 36.0.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
            ),
            child: Center(
              child: Image.asset(
                this.assets,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            this.text,
            style: TextStyle(fontSize: 10.sp),
          )
        ],
      ),
    );
  }
}
