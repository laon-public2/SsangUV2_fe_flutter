import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/mypage/ChangePassword.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';

class MyPageModified extends StatefulWidget {
  @override
  _MyPageModifiedState createState() => _MyPageModifiedState();
}

class _MyPageModifiedState extends State<MyPageModified> {
  TextEditingController userNameContorller = TextEditingController();

  void initState() {
    super.initState();
    // setState(() {
    //   this._userNameContorller.text = Provider.of<UserProvider>(context, listen: false).username;
    // });
  }

  final picker = ImagePicker();

  List<Asset> images = List<Asset>();
  String _isDialogText;

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "프로필 사진 변경",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    return Consumer<UserProvider>(
      builder: (_, _user, __) {
        return Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(right: 10, left: 10, top: 30),
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
                            '프로필 수정',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 23.sp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //바디 부분 수정시 여기 참조
                // 1. 프로필사진
                Container(
                  width: double.infinity,
                  height: 200.h,
                  child: Center(
                    child: Container(
                      width: 150.w,
                      height: 150.h,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xffdddddd), width: 1.0),
                        borderRadius: BorderRadius.circular(150),
                      ),
                      child: InkWell(
                        onTap: () async {
                          await loadAssets();
                          await _user.userImgChange(
                            images,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: _user.userProfileImg != null
                              ? Container(
                                  width: 130.w,
                                  height: 130.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: Image.network(
                                      "http://192.168.100.232:5066/assets/images/user/${_user.userProfileImg}",
                                      height: 120.h,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Icon(Icons.account_circle,
                                  color: Colors.grey, size: 130.0),
                        ),
                      ),
                    ),
                  ),
                ),
                //2. 유저 이름
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
                              '유저 이름 변경',
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
                          controller: userNameContorller,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "유저 이름 입력",
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
                    if (this.userNameContorller.text == "") {
                      setState(() {
                        _isDialogText = "유저이름이 입력되지 않았습니다.";
                      });
                      _showDialog();
                    } else {
                      String status =
                          await _user.userInfoChange(userNameContorller.text);
                      if (status == 'false') {
                        setState(() {
                          _isDialogText = "유저이름이 변경중 에러가 발생했습니다.";
                        });
                        _showDialog();
                      } else {
                        setState(() {
                          _isDialogText = "유저이름이 변경되었습니다.";
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
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context)=> ChangePassword())
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 30.h,
                    child: Center(
                      child: Text(
                        '비밀번호 변경',
                        style: TextStyle(
                          color: Color(0xff28527a),
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
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
