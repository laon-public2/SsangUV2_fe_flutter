import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/userProvider.dart';

class RemoveAccount extends StatefulWidget {
  final String phNum;

  RemoveAccount({this.phNum});
  @override
  _RemoveAccountState createState() => _RemoveAccountState();
}

class _RemoveAccountState extends State<RemoveAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar(){
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 25.0.sp,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  _body(){
    return Consumer<UserProvider>(
      builder: (_, myInfo, __){
        return SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.only(top: 5.0, left: 16, right: 16, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '정말\n탈퇴하실건가요?',
                  style: TextStyle(
                    fontSize: 30.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  '탈퇴 시 주의 사항',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '탈퇴 시 모든 정보가 사라지지 않습니다.\n회원 간의 거래의 기록을 위해,\n아래 사항의 정보는 남게됩니다.',
                  style: TextStyle(
                    color: Color(0xff737373),
                    fontWeight: FontWeight.w300,
                    fontSize: 15.sp,
                  ),
                ),
                //1. 채팅기록
                SizedBox(height: 30.h),
                Text(
                  '1. 채팅기록',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '법적 분쟁을 위해 회원간의 기록은 DB에 계속 저장됩니다.\n삭제를 원할 시 고객센터로 문의 주십시오.',
                  style: TextStyle(
                    color: Color(0xff737373),
                    fontWeight: FontWeight.w300,
                    fontSize: 15.sp,
                  ),
                ),
                //2. 상품
                SizedBox(height: 30.h),
                Text(
                  '2. 상품',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '탈퇴를 하시더라도 상품에 대한 정보는 DB에 남게 됩니다.\n탈퇴 후 해당 상품은 검색되지 않습니다.',
                  style: TextStyle(
                    color: Color(0xff737373),
                    fontWeight: FontWeight.w300,
                    fontSize: 15.sp,
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        await myInfo.DeleteUser(myInfo.phNum);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: Container(
                        width: 211.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Color(0xffe83023),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '회원탈퇴',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

