import "package:flutter/material.dart";
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/auth/changeAddress.dart';
import 'package:share_product_v2/pages/mypage/MyComModified.dart';
import 'package:share_product_v2/pages/mypage/MyPageModified.dart';
import 'package:share_product_v2/pages/mypage/RemoveAccount.dart';
import 'package:share_product_v2/providers/mapProvider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';
import '../KakaoMap.dart';

class MyInfo extends StatefulWidget {
  @override
  _MyInfo createState() => _MyInfo();
}

class _MyInfo extends State<MyInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        '내 프로필',
        style: TextStyle(color: Colors.black, fontSize: 17.sp),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 25.0.sp,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 1.0,
    );
  }

  _body() {
    return Consumer<UserProvider>(
      builder: (context, myInfo, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(bottom: 20),
          color: Colors.white,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          MyPageModified()
                      )
                  );
                },
                child: ListTile(
                  leading: myInfo.userProfileImg != null
                      ? Hero(
                        tag: "MyProfileImg",
                        child: Container(
                            width: 50.w,
                            height: 50.h,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                "http://115.91.73.66:15066/assets/images/user/${myInfo.userProfileImg}",
                              ),
                            ),
                          ),
                      )
                      : Hero(
                        tag: "MyProfileImg",
                        child: Icon(Icons.account_circle,
                            color: Colors.grey, size: 50.0),
                      ),
                  title: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${myInfo.username}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          myInfo.userType == "BUSINESS" ? "대여업체" : "",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Color(0xffff0066),
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    _numberFormat(myInfo.phNum),
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff666666),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Divider(height: 1.0),
              SizedBox(height: 5.h),
              myInfo.comNum != null
                  ? ListTile(
                      title: Text(
                        "사업자정보",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: InkWell(
                        onTap: () {
                          _showDialog("${myInfo.comIdentity}");
                        },
                        child: Text(
                          myInfo.comNum,
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                      trailing: SizedBox(
                        width: 24,
                        height: 24,
                        child: IconButton(
                          padding: new EdgeInsets.all(0.0),
                          icon: Image.asset('assets/icon/write.png'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyComModified(comName: myInfo.comIdentity, comNum: myInfo.comNum))
                            );
                          },
                        ),
                      ),
                    )
                  : SizedBox(),
              myInfo.comNum != null
                  ? Column(
                      children: [
                        Divider(height: 1.0),
                        SizedBox(height: 15),
                      ],
                    )
                  : SizedBox(),
              ListTile(
                title: Text(
                  "나의 주소 변경",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                subtitle: InkWell(
                  onTap: () async {
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
                          builder: (context) => ChangeAddress(
                              double.parse(positionSplit[1]),
                              double.parse(positionSplit[0]),
                              "${model.sido} ${model.sigungu} ${model.bname}",
                              "${model.buildingName.replaceAll('Y','').replaceAll('N', '')}${model.apartment.replaceAll('Y','').replaceAll('N', '')}"),
                        ));
                  },
                  child: Text(
                    "${myInfo.address} ${myInfo.addressDetail}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff666666),
                    ),
                  ),
                ),
                trailing: SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    padding: new EdgeInsets.all(0.0),
                    icon: Image.asset('assets/icon/write.png'),
                    onPressed: () async {
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
                      print("설정 주소 $position");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeAddress(
                                double.parse(positionSplit[0]),
                                double.parse(positionSplit[1]),
                                "${model.sido} ${model.sigungu} ${model.bname}",
                                "${model.buildingName.replaceAll('Y','').replaceAll('N', '')}${model.apartment.replaceAll('Y','').replaceAll('N', '')}"),
                          ));
                    },
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () async{
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RemoveAccount(phNum: myInfo.phNum))
                        );
                      },
                      child: Center(
                        child: Text(
                          '회원탈퇴',
                          style: TextStyle(
                            color: Color(0xffe40017),
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) =>
                    //           MyPageModified()
                    //       )
                    //     );
                    //   },
                    //   child: Center(
                    //     child: Text(
                    //       '회원정보 수정',
                    //       style: TextStyle(
                    //         color: Color(0xff28527a),
                    //         fontSize: 15.sp,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _numberFormat(String phNum) {
    var value = phNum;
    value = value.replaceAll(
        RegExp(r'\B(?=(\d{3})+(?!\d)+(\d{3,4})+(?!\d)+(\d{4}))'), "-");
    return value;
  }

  void _showDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogApply(
          SizedBox(
            width: 300,
            height: 300,
            child: Image.network(
              "http://115.91.73.66:15066/assets/images/business/$text",
              height: 300.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          '확인',
        );
      },
    );
  }
}
