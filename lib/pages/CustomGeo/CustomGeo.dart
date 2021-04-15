import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomGeo extends StatefulWidget {
  @override
  _CustomGeoState createState() => _CustomGeoState();
}

class _CustomGeoState extends State<CustomGeo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
  _body(){
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 10, bottom: 20, left: 16, right: 16),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Text(
                  "원하는",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  " 범위설정",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
