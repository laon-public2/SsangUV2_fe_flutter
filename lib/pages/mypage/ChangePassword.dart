import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late String _isDialogText;
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController chkPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _body(),
    );
  }

  _body() {
    return Consumer<UserProvider>(
      builder: (_, _user, __){
        return Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //appbar 부분을 바디에 넣었음.
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 20.0.sp,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            '사용자의\n비밀번호를\n변경합니다.',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 28.sp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 50.h),
                Container(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  width: double.infinity,
                  height: 80.h,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              '기존 비밀번호 입력',
                              style: TextStyle(
                                color: Color(0xff999999),
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xffdddddd),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          obscureText: true,
                          controller: currentPassword,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "기존 비밀번호 입력",
                            hintStyle: TextStyle(
                                fontSize: 14, color: Color(0xffaaaaaa)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  width: double.infinity,
                  height: 80.h,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              '새로운 비밀번호 입력',
                              style: TextStyle(
                                color: Color(0xff999999),
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xffdddddd),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          obscureText: true,
                          controller: newPassword,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "새로운 비밀번호 입력",
                            hintStyle: TextStyle(
                                fontSize: 14, color: Color(0xffaaaaaa)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  width: double.infinity,
                  height: 80.h,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              '비밀번호 확인',
                              style: TextStyle(
                                color: Color(0xff999999),
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xffdddddd),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          obscureText: true,
                          controller: chkPassword,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "비밀번호 확인",
                            hintStyle: TextStyle(
                                fontSize: 14, color: Color(0xffaaaaaa)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                InkWell(
                  onTap: () async {
                    if (this.currentPassword.text == "") {
                      setState(() {
                        _isDialogText = "현재 비밀번호가 입력되지 않았습니다.";
                      });
                      _showDialog();
                    }else if(this.newPassword.text == ""){
                      setState(() {
                        _isDialogText = "새로운 비밀번호가 입력되지 않았습니다.";
                      });
                      _showDialog();
                    }else if(this.chkPassword.text == ""){
                      setState(() {
                        _isDialogText = "비밀번호 확인란에 입력해주십시오.";
                      });
                      _showDialog();
                    }else if(this.newPassword.text != this.chkPassword.text){
                      setState(() {
                        _isDialogText = "비밀번호가 서로 일치 하지 않습니다.";
                      });
                      _showDialog();
                    } else {
                      String? status = await _user.userChangePwd(this.currentPassword.text, this.newPassword.text);
                      if (status == 'false') {
                        setState(() {
                          _isDialogText = "비밀번호 변경중 오류가 발생했습니다.";
                        });
                        _showDialog();
                      } else {
                        setState(() {
                          _isDialogText = "비밀번호가 변경되었습니다.";
                        });
                        _showDialog();
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Container(
                      width: double.infinity,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Color(0xffff0066),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '변경완료',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApply(Center(child: Text(_isDialogText)), '확인');
        });
  }
}
