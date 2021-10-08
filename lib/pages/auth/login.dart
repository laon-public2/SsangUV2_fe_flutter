import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/productController.dart';
import 'package:share_product_v2/providers/regUserController.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/providers/userController.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';
import 'package:share_product_v2/widgets/loading.dart';

class LoginPageNode extends StatefulWidget {
  @override
  _LoginPageNodeState createState() => _LoginPageNodeState();
}

class _LoginPageNodeState extends State<LoginPageNode> with SingleTickerProviderStateMixin {

  ProductController productController = Get.find<ProductController>();
  TextEditingController _phNum = TextEditingController();
  TextEditingController _password = TextEditingController();
  UserController userController = Get.find<UserController>();
  String? phNum;


  late AnimationController _aniController;
  late Animation<Offset> _offsetAnimation;
  double _visible = 0.0;

  @override
  void initState() {
    super.initState();
    _aniController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _aniController,
      curve: Curves.fastOutSlowIn,
    ));
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _visible = 1.0;
      });
    });

  }

  @override
  void dispose() {
    _aniController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: GetBuilder<UserController>(
        builder: (counter) {
          return SingleChildScrollView(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
              child: Column(
                children: <Widget>[
                  AnimatedOpacity(
                    opacity: _visible,
                    duration: Duration(milliseconds: 500),
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '계정을\n입력해주세요.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  TextField(
                    controller: _phNum,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "전화번호 입력",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "비밀번호 입력",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  InkWell(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      if (_phNum.text == '') {
                        _showDialog('전화번호가 입력되지 않았습니다.');
                        return;
                      } else if (_password.text == "") {
                        _showDialog('비밀번호가 입력되지 않았습니다.');
                      } else {
                        await counter.getAccessToken(_phNum.text, _password.text);
                        if (counter.isLoggenIn.value) {
                          _showDialogLoading();

                          await productController.getGeolocator();
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        } else {
                          _showDialog('전화번호 또는 아이디가 틀렸습니다.');
                        }
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Color(0xffff0066),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '로그인',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _appBar() {
    return AppBar(
      leading: Container(
        padding: const EdgeInsets.only(left: 16),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
    );
  }


  void _showDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApply(Center(child: Text(text)), '확인');
        });
  }

  void _showDialogLoading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Loading();
        });
  }
}
