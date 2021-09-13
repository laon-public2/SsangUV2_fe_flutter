import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/auth/loginMyPage.dart';
import 'package:share_product_v2/pages/auth/noLoginMyPage.dart';
import 'package:share_product_v2/providers/userProvider.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
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
        body: Consumer<UserProvider>(
          builder: (context, counter, child) {
            return Stack(
              children: [
                Provider.of<UserProvider>(context, listen: false).isLoggenIn
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
