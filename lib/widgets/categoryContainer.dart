import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryContainer extends StatelessWidget {
  final String category;

  CategoryContainer({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 18,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: Center(
        child: Center(
          child: Text(
            category,
            style:
                TextStyle(fontSize: 10.sp, color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
