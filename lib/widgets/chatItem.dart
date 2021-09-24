import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatItem extends StatelessWidget {
  final String text;
  final Color color;
  final Alignment alignment;
  ChatItem({required this.text, required this.color, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 244,
        minHeight: 44,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: color,
        boxShadow: [
          BoxShadow(
            offset: Offset(0,1),
            blurRadius: 4,
            color: Color.fromRGBO(0, 0, 0, 0.15),
          )
        ]
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: TextStyle(fontSize: 14.sp,),)
        ],
      ),
    );
  }
}
