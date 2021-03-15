import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/regUserProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';

class LoginPageNode extends StatefulWidget {
  @override
  _LoginPageNodeState createState() => _LoginPageNodeState();
}

class _LoginPageNodeState extends State<LoginPageNode> {
  TextEditingController _phNum = TextEditingController();
  TextEditingController _password = TextEditingController();
  String phNum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Consumer<UserProvider>(
        builder: (context, counter, child) {
          return _body();
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
        child: Column(
          children: <Widget>[
            Container(
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
                  await Provider.of<UserProvider>(context, listen: false)
                      .getAccessToken(_phNum.text, _password.text);
                  if (Provider.of<UserProvider>(context, listen: false)
                      .isLoggenIn) {
                    await Provider.of<ProductProvider>(context, listen: false).getGeolocator();
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
  }

  void _showDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApply(Center(child: Text(text)), '확인');
        });
  }
}
