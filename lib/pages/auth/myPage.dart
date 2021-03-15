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
  bool isLogin = false;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
