import 'package:flutter/material.dart';
import 'package:share_product_v2/consts/textStyle.dart';

class CustomOnlyTextContainer extends StatelessWidget {
  final String title;

  CustomOnlyTextContainer({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
            "$title",
            style: normal_16_000,
        ),
      ),
    );
  }
}
