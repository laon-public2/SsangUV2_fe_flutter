import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/auth/loginMyPage.dart';
import 'package:share_product_v2/pages/auth/noLoginMyPage.dart';
import 'package:share_product_v2/providers/userController.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  UserController userController = Get.find<UserController>();
  double _visible = 0.0;
  bool isLogin = false;
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _visible = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible,
      duration: Duration(milliseconds: 100),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<UserController>(
          builder: (counter) {
            return Stack(
              children: [
                userController.isLoggenIn.value
                    ? LoginMyPage()
                    : NoLoginMyPage(),
                // LoginMyPage(),
              ],
            );
          },
        ),
      ),
    );
  }
}
