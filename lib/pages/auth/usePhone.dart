import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/regUserProvider.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';

class UsePhone extends StatefulWidget {
  @override
  _UsePhoneState createState() => _UsePhoneState();
}

class _UsePhoneState extends State<UsePhone> {
  TextEditingController _myPh = TextEditingController();
  TextEditingController _myPhact = TextEditingController();
  String _isDialogText;
  bool isPhAct = false;
  // final isPhoneActive =
  var maskFormatter = new MaskTextInputFormatter(
      mask: '###-####-####', filter: {"#": RegExp(r'[0-9]')});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Consumer<RegUserProvider>(
        builder: (context, counter, child) {
          return _body();
        },
      ),
    );
  }

  _body() {
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 30),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '휴대폰 번호를\n입력해주세요.',
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
                      controller: _myPh,
                      keyboardType: TextInputType.number,
                      // inputFormatters: [maskFormatter],
                      decoration: InputDecoration(
                        labelText: "번호입력",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    if (isPhAct)
                      TextField(
                        controller: _myPhact,
                        decoration: InputDecoration(
                          labelText: "인증번호 입력",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    // Spacer(),
                    SizedBox(height: 30.h),
                    isPhAct
                        ? InkWell(
                      onTap: () async {
                        if (_myPhact.text == "") {
                          setState(() {
                            _isDialogText = "인증 번호가 입력되지 않았습니다.";
                          });
                          _showDialog();
                        } else {
                          await Provider.of<RegUserProvider>(context, listen: false)
                              .phoneActCon(_myPh.text, _myPhact.text);
                          if (Provider.of<RegUserProvider>(context, listen: false)
                              .phoneActive) {
                            print('비동기 처리');
                            Navigator.pushNamed(context, '/chioceUser');
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Color(0xffff0066),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '인증번호 인증',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                        : InkWell(
                      onTap: () async {
                        if (_myPh.text == "") {
                          setState(() {
                            _isDialogText = "휴대폰 번호가 입력되지 않았습니다.";
                          });
                          _showDialog();
                        } else {
                          await Provider.of<RegUserProvider>(context, listen: false)
                              .regUserChk(_myPh.text);
                          if (Provider.of<RegUserProvider>(context, listen: false)
                              .chkUserChk ==
                              false) {
                            Navigator.pushNamed(context, '/loginNode');
                          } else {
                            setState(() {
                              isPhAct = true;
                            });
                            Provider.of<RegUserProvider>(context, listen: false)
                                .phoneAct(_myPh.text);
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Color(0xffff0066),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '인증요청',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApply(Center(child: Text(_isDialogText)), '확인');
        });
  }

  _appBar() {
    return AppBar(
      actions: [
        Container(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: InkWell(
              onTap: () {
                Provider.of<RegUserProvider>(context, listen: false).backBtn();
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close_sharp,
                size: 25.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
