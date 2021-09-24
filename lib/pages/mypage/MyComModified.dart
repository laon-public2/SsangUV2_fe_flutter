import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/mypage/ChangePassword.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';
import 'dart:io';

class MyComModified extends StatefulWidget {
  final String comName;
  final String comNum;
  MyComModified({required this.comName, required this.comNum});
  @override
  _MyPageModifiedState createState() => _MyPageModifiedState();
}

class _MyPageModifiedState extends State<MyComModified> with SingleTickerProviderStateMixin {
  TextEditingController userNameContorller = TextEditingController();

  //애니메이션
  late AnimationController _aniController;
  late Animation<Offset> _offsetAnimation;
  double _visible = 0.0;


  void initState() {
    super.initState();
    _aniController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset> (
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
    // setState(() {
    //   this._userNameContorller.text = Provider.of<UserProvider>(context, listen: false).username;
    // });
  }
  final picker = ImagePicker();
  late File _images;
  late String _isDialogText;

  Future<void> loadAssets() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null){
        _images = File(pickedFile.path);
      }else{
        print("No image selected");
      }
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
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity: _visible,
                            child: SlideTransition(
                              position: _offsetAnimation,
                              child: Text(
                                '사업자정보 수정',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 23.sp),
                              ),
                            ),
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
                          await _user.userComChange(
                            _images,
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
                                      "http://115.91.73.66:15066/assets/images/business/${_user.comIdentity}",
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
                //2. 사업자 등록
                Container(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  width: double.infinity,
                  height: 80.h,
                  child: Column(
                    children: <Widget>[
                      Text(
                        '사업자 등록번호',
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        this.widget.comNum,
                        style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 20.sp,
                        ),
                      )
                    ],
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
