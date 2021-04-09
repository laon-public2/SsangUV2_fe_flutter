import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _willPopCallback(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.2),
        child: Center(
          child: Image.asset("assets/loading1.gif", width: 48.0, height: 48.0,),
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    return true;
  }
}