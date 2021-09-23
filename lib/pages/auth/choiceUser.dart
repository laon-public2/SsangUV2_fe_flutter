import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/fcm_model.dart';
import 'package:share_product_v2/providers/mapProvider.dart';
import 'package:share_product_v2/providers/regUserProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';
import 'package:share_product_v2/widgets/customdialogApplyReg.dart';

import '../../main.dart';
import '../KakaoMap.dart';
import 'changeAddress.dart';
import 'changeAddressReg.dart';

TextEditingController name = TextEditingController();
TextEditingController pwd = TextEditingController();
TextEditingController chkPwd = TextEditingController();
TextEditingController comNum = TextEditingController();
bool _company = false;
File regimage;

String userType = "NOMAL";

class ChoiceUser extends StatefulWidget {
  @override
  _ChoiceUserState createState() => _ChoiceUserState();
}

class _ChoiceUserState extends State<ChoiceUser> with TickerProviderStateMixin {
  var maskComNumFomatter = new MaskTextInputFormatter(
      mask: '###-##-#####', filter: {'#': RegExp(r'[0-9]')});
  final ImagePicker _picker = ImagePicker();



  Future _getImage() async {
    PickedFile image;
    setState(() {
      image = null;
    });
    image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      regimage = File(image.path);
    });
  }

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

  _body() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Text(
                          '일반회원',
                          style: TextStyle(
                            color: !_company ? Colors.black : Color(0xff999999),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _company = false;
                            userType = "NOMAL";
                          });
                        },
                      ),
                      Text(
                        '|',
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _company = true;
                            userType = "BUSINESS";
                          });
                        },
                        child: Text(
                          '대여업체',
                          style: TextStyle(
                            color: _company ? Colors.black : Color(0xff999999),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Text(
                        '회원구분을 선택해주세요.',
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 13,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _company
                ? Column(
                    children: <Widget>[
                      SizedBox(height: 30.h),
                      _formField('닉네임', name, false),
                      SizedBox(height: 18.h),
                      _formField('비밀번호', pwd, true),
                      SizedBox(height: 10.h),
                      Text(
                        '비밀번호는 소문자, 숫자, 특수문자를 합하여 10자 이상이여야 합니다.',
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 13,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      _formField('비밀번호 확인', chkPwd, true),
                      SizedBox(height: 18.h),
                      _companyField(comNum),
                      SizedBox(height: 30.h),
                      _regComDone(),
                      SizedBox(height: 30.h),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      SizedBox(height: 30.h),
                      _formField('닉네임', name, false),
                      SizedBox(height: 18.h),
                      _formField('비밀번호', pwd, true),
                      SizedBox(height: 10.h),
                      Text(
                        '비밀번호는 소문자, 숫자, 특수문자를 합하여 10자 이상이여야 합니다.',
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 13,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      _formField('비밀번호 확인', chkPwd, true),
                      SizedBox(height: 60.h),
                      _regDone(),
                      SizedBox(height: 30.h),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  _regDone() {
    return InkWell(
      onTap: () async {
        bool validatePassword = _validatePassword(pwd.text);
        if (name.text == '') {
          _showDialog('이름이 입력되지 않았습니다.');
          return;
        }
        if (pwd.text == '') {
          _showDialog('비밀번호가 입력되지 않았습니다.');
          return;
        }
        if (chkPwd.text == '') {
          _showDialog('비밀번호확인란이 입력되지 않았습니다.');
          return;
        }
        if (chkPwd.text != pwd.text) {
          _showDialog('비밀번호가 서로 일치하지 않습니다.');
          return;
        } if(validatePassword == false){
          _showDialog('비밀번호의 형식이 옯바르지 않습니다.');
          return;
        } else {
          // await Provider.of<RegUserProvider>(context, listen: false)
          //     .regUserForm(
          //   pwd.text,
          //   name.text,
          //   userType,
          //   '1',
          //   comNum.text,
          //   regimage,
          //   Provider.of<FCMModel>(context, listen: false).mbToken,
          // );
          // await Provider.of<UserProvider>(context, listen: false).getAccessTokenReg(
          //   Provider.of<RegUserProvider>(context, listen: false).phNum,
          //   pwd.text,
          // );
          // if (Provider.of<RegUserProvider>(context, listen: false)
          //     .regUserTruth) {
            await localhostServer.close();
            await localhostServer.start();
            KopoModel model =
            await Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  KakaoMap(),
            ));
            String position =
            await Provider.of<MapProvider>(context, listen: false)
                .getPosition(model.address);
            List<String> positionSplit = position.split(',');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeAddressReg(
                      double.parse(positionSplit[0]),
                      double.parse(positionSplit[1]),
                      "${model.sido} ${model.sigungu} ${model.bname}",
                      "${model.buildingName.replaceAll('Y','').replaceAll('N', '')}${model.apartment.replaceAll('Y','').replaceAll('N', '')}"),
                ));
            // _showDialogSuccess('회원가입이 완료되었습니다.');
            // Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
          // }else {
          //   _showDialogSuccess('해당 전화번호는 이미 존재하는 회원입니다.');
          // }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50.h,
        decoration: BoxDecoration(
          color: Color(0xffff0066),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Text(
          '완료',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
          ),
        )),
      ),
    );
  }

  _regComDone() {
    return InkWell(
      onTap: () async {
        bool validatePassword = _validatePassword(pwd.text);
        if (name.text == '') {
          _showDialog('이름이 입력되지 않았습니다.');
          return;
        }
        if (pwd.text == '') {
          _showDialog('비밀번호가 입력되지 않았습니다.');
          return;
        }
        if (chkPwd.text == '') {
          _showDialog('비밀번호확인란이 입력되지 않았습니다.');
          return;
        } if (chkPwd.text != pwd.text) {
          _showDialog('비밀번호가 서로 일치하지 않습니다.');
          return;
        }
        if(validatePassword == false){
          _showDialog("비밀번호의 형식이 옯바르지 않습니다.");
          return;
        }
        if (regimage == null) {
          _showDialog('사업자 등록증 파일이 업로드 되지 않았습니다.');
          return;
        }
        if (regimage == null) {
          _showDialog('사업자 등록증 파일이 업로드 되지 않았습니다.');
          return;
        }
        if (comNum.text == '') {
          _showDialog('사업자 등록번호가 비어 있습니다.');
          return;
        } else {
          await Provider.of<RegUserProvider>(context, listen: false)
              .regUserForm(
            pwd.text,
            name.text,
            userType,
            '1',
            comNum.text,
            regimage,
            Provider.of<UserProvider>(context, listen: false).userFBtoken,
          );
          if (Provider.of<RegUserProvider>(context, listen: false).regUserTruth) {
            await localhostServer.close();
            await localhostServer.start();

            KopoModel model =
            await Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  KakaoMap(),
            ));
            String position =
            await Provider.of<MapProvider>(context, listen: false)
                .getPosition(model.address);
            List<String> positionSplit = position.split(',');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeAddressReg(
                      double.parse(positionSplit[0]),
                      double.parse(positionSplit[1]),
                      "${model.sido} ${model.sigungu} ${model.bname}",
                      "${model.buildingName.replaceAll('Y','').replaceAll('N', '')}${model.apartment.replaceAll('Y','').replaceAll('N', '')}"),
                ));
          } else {
            _showDialogSuccess('해당 전화번호는 이미 존재하는 회원입니다.');
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
          '완료',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
          ),
        )),
      ),
    );
  }

  _companyField(TextEditingController _comNum) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (regimage == null) {
                        _getImage();
                      } else {
                        setState(() {
                          regimage = null;
                        });
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          border:
                              Border.all(color: Color(0xffdddddd), width: 1.0)),
                      child: Center(
                        child: Text(
                          regimage == null ? '파일첨부' : '파일 삭제',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        regimage == null
                            ? '사업자 등록증 사본을 첨부하여 주세요.'
                            : '사업자 등록증이 업로드 되었습니다.',
                        style: TextStyle(
                          fontSize: 13,
                          color: regimage == null
                              ? Color(0xff999999)
                              : Colors.green[300],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Column(
                children: [
                  TextField(
                    inputFormatters: [maskComNumFomatter],
                    keyboardType: TextInputType.number,
                    controller: _comNum,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffdddddd)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffdddddd)),
                        ),
                        isDense: true, // 크기조절
                        contentPadding: EdgeInsets.all(13) //크기조절,
                        ),
                  ),
                  Row(
                    children: [
                      Text(
                        '사업자 등록 번호를 적어주세요.',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xff999999)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _formField(
      String title, TextEditingController _controller, bool passwordType) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          TextField(
            obscureText: passwordType,
            controller: _controller,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Color(0xffdddddd)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Color(0xffdddddd)),
                ),
                isDense: true, // 크기조절
                contentPadding: EdgeInsets.all(13) //크기조절,
                ),
          ),
        ],
      ),
    );
  }

  bool _validatePassword(String value){
    String pattern = r'^(?=.*?[a-z)(?=.*?[0-9])(?=.*?[!@#\$&*~]).{10,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void _showDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApply(Center(child: Text(text)), '확인');
        });
  }

  void _showDialogSuccess(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApplyReg(Center(child: Text(text)), '확인');
        });
  }
}
