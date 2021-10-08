import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/userController.dart';
import 'package:share_product_v2/widgets/customAppBar%20copy.dart';

class NoticePage extends StatelessWidget {

  int page = 0;
  UserController userController = Get.find<UserController>();

  Future<bool> _noticeLoad() async{
    await userController.noticeView(this.page);
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWithPrev(appBar: AppBar(), title: "알림", elevation: 1.0,),
      body: FutureBuilder(
        future: _noticeLoad(),
        builder: (context, snapshot){
          if(snapshot.hasData == false){
            return Container(
              height: 300.h,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Color(0xffff0066)),
                ),
              ),
            );
          }else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              ),
            );
          } else {
            return body();
          }
        },
      ),
    );
  }

  Widget body() {
    return GetBuilder<UserController>(
      builder: (_user){
        return ListView.builder(
          itemBuilder: (context, idx) {
            if(idx == _user.userNoticeList.length){
              if(idx == _user.userNotice.totalCount){
                return Container();
              }else {
                this.page++;
                userController.noticeView(this.page);
              }
            }
            if(_user.userNoticeList[idx].status == "START"){
              return Item("${_user.userNoticeList[idx].receiver}님이 ${_user.userNoticeList[idx].title} 대여를 시작하였습니다.", "${_timeCompare(_user.userNoticeList[idx].createAt)}", idx == 0, _user.userNoticeList[idx].productFiles[0].path);
            }else if(_user.userNoticeList[idx].status == "END"){
              return Item("${_user.userNoticeList[idx].receiver}님이 ${_user.userNoticeList[idx].title} 대여를 종료하였습니다.", "${_timeCompare(_user.userNoticeList[idx].createAt)}", idx == 0, _user.userNoticeList[idx].productFiles[0].path);
            }else{
              return Item("${_user.userNoticeList[idx].receiver}님이 ${_user.userNoticeList[idx].title} 대해 답글을 하였습니다.", "${_timeCompare(_user.userNoticeList[idx].createAt)}", idx == 0, _user.userNoticeList[idx].productFiles[0].path);
            }
          },
          itemCount: _user.userNoticeList.length,
        );
      },
    );
  }
  _timeCompare(String originaltime) {
    var now = new DateTime.now();
    var original = DateTime.parse(originaltime);
    Duration diff = now.difference(original);
    return diff.inDays;
  }
}

class Item extends StatelessWidget {
  final String content;
  final String time;
  final bool isNew;
  final String pic;

  Item(this.content, this.time, this.isNew, this.pic);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, right: 20),
                child: CircleAvatar(
                  radius: 17.h,
                  backgroundImage: NetworkImage(
                    "http://115.91.73.66:15066/assets/images/product/$pic",
                  ),
                ),
              ),
              // Positioned(
              //   top: 0,
              //   left: 40,
              //   child: CircleAvatar(
              //     radius: 8.h,
              //     backgroundImage: isNew ? AssetImage('assets/new.png') : null,
              //     backgroundColor: Colors.white.withAlpha(0),
              //   ),
              // ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                content,
                style: TextStyle(color: Color(0xff333333), fontSize: 12.h),
              ),
              SizedBox(
                height: 3,
              ),
              Text("$time일 전",
                  style: TextStyle(color: Color(0xff999999), fontSize: 10.h))
            ],
          )
        ],
      ),
    );
  }
}
