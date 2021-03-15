import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/widgets/customText.dart';

class CategoryText extends StatelessWidget {
  final String category;

  CategoryText(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor)),
        child: CustomText(
          text: category == null ? "" : category,
          fontSize: 12.sp,
          textColor: Theme.of(context).primaryColor,
        ));
  }
}
