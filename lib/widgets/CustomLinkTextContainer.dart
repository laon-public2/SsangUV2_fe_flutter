import 'package:flutter/material.dart';
import 'package:share_product_v2/consts/textStyle.dart';

class CustomLinkTextContainer extends StatelessWidget {
  final String title;
  final String link;

  CustomLinkTextContainer({this.title, this.link});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: InkWell(
          child: Text(
            "$title",
            style: normal_16_000,
          ),
          onTap: () => Navigator.pushNamed(context, '$link'),
        ),
      ),
    );
  }
}
