import 'package:flutter/material.dart';
import 'package:share_product_v2/consts/textStyle.dart';

class CustomLinkTextContainer extends StatelessWidget {
  final String title;
  final String link;

  CustomLinkTextContainer({required this.title, required this.link});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 52,
        width: double.infinity,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "$title",
            style: normal_16_000,
          ),
        ),
      ),
      onTap: () => Navigator.pushNamed(context, '$link'),
    );
  }
}
