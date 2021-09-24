import 'package:flutter/cupertino.dart';
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

class _UsePhoneState extends State<UsePhone>
    with SingleTickerProviderStateMixin {

  late AnimationController _aniController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _aniController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )
      ..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
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

  TextEditingController _myPh = TextEditingController();
  TextEditingController _myPhact = TextEditingController();
  String? _isDialogText;
  bool isPhAct = false;
  double _height = 290;
  String phActString = "인증번호 발송";
  double _visible = 0.0;

  Future<String> _fetch1() async {
    await Future.delayed(Duration(seconds: 10));
    return 'lateNum';
  }

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
    return AnimatedContainer(
      width: double.infinity,
      height: _height,
      duration: Duration(milliseconds: 900),
      curve: Curves.fastOutSlowIn,
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 20, bottom: 30),
                child: Column(
                  children: <Widget>[
                    AnimatedOpacity(
                      opacity: _visible,
                      duration: Duration(milliseconds: 500),
                      child: AnimatedCrossFade(
                        firstChild: SlideTransition(
                          position: _offsetAnimation,
                          child: Container(
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
                        ),
                        secondChild: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '인증번호를\n입력해주세요.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        crossFadeState: isPhAct
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: Duration(milliseconds: 500),
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
                    // if (isPhAct)
                    AnimatedCrossFade(
                      firstChild: Column(
                        children: [
                          SizedBox(height: 5.h),
                          TextField(
                            controller: _myPhact,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "인증번호 입력",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          FutureBuilder(
                            future: _fetch1(),
                            builder: (context, snapshot) {
                              return InkWell(
                                onTap: () {
                                  Provider.of<RegUserProvider>(
                                      context, listen: false)
                                      .phoneAct(_myPh.text);
                                },
                                child: Container(
                                  height: 45.h,
                                  child: Center(
                                    child: Text(
                                      "인증번호 재요청",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Color(0xffff0066),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                      secondChild: Container(color: Colors.white),
                      crossFadeState: isPhAct
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 500),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 20, bottom: 20),
              child: InkWell(
                onTap: () async {
                  if (isPhAct) {
                    if (_myPhact.text == "") {
                      setState(() {
                        _isDialogText = "인증 번호가 입력되지 않았습니다.";
                      });
                      _showDialog();
                    } else {
                      await Provider.of<RegUserProvider>(context, listen: false)
                          .phoneActCon(_myPh.text, _myPhact.text);
                      if (Provider
                          .of<RegUserProvider>(context, listen: false)
                          .phoneActive) {
                        print('비동기 처리');
                        Navigator.pushNamed(context, '/chioceUser');
                      } else {
                        setState(() {
                          _isDialogText = "인증번호가 틀립니다.\n다시 요청해주세요.";
                        });
                        _showDialog();
                      }
                    }
                  } else {
                    if (_myPh.text == "") {
                      setState(() {
                        _isDialogText = "휴대폰 번호가 입력되지 않았습니다.";
                      });
                      _showDialog();
                    } else {
                      setState(() {
                        _height = 400;
                      });
                      setState(() {
                        phActString = "인증번호 인증";
                      });
                      await Provider.of<RegUserProvider>(context, listen: false)
                          .regUserChk(_myPh.text);
                      if (Provider
                          .of<RegUserProvider>(context, listen: false)
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
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Color(0xffff0066),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '$phActString',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
          return CustomDialogApply(Center(child: Text(_isDialogText!)), '확인');
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
