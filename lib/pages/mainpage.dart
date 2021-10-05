import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/history/history.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/pages/home.dart';
import 'package:share_product_v2/pages/auth/myPage.dart';
import 'package:share_product_v2/pages/product/ProductReg.dart';
import 'package:share_product_v2/pages/product/productApplyPage.dart';
import 'package:share_product_v2/pages/product/productHelpReg.dart';
import 'package:share_product_v2/providers/bannerProvider.dart';
import 'package:share_product_v2/providers/fcm_model.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/utils/APIUtil.dart';
import 'package:share_product_v2/widgets/CustomPopup.dart';
import 'package:share_product_v2/widgets/InputDoneView.dart';
import 'package:share_product_v2/widgets/PageTransition.dart';
import 'package:share_product_v2/widgets/customdialog.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';



int bottomSelectedIndex = 0;

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      // SharedPreferences pref = await SharedPreferences.getInstance();
      // String token = pref.get("access_token");
      // print("token : $token");
      // if (token != null && token != "") {
      //   Provider.of<UserProvider>(context, listen: false).setAccessToken(token);
      //   Provider.of<UserProvider>(context, listen: false).me();
      // }
    });
    return MyStatefulWidget();
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key? key}) : super(key: key);
  static MyStatefulWidgetState? of(BuildContext context) => context.findAncestorStateOfType<MyStatefulWidgetState>();
  @override
  MyStatefulWidgetState createState() => MyStatefulWidgetState();

}

class MyStatefulWidgetState extends State<MyStatefulWidget> {
  // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  late SharedPreferences pref;
  int page = 0;
  OverlayEntry? overlayEntry;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Text(
      '글쓰기',
      style: optionStyle,
    ),
    /**
     * NOTICE : 계약 기능 및 채팅 기능이 삭제됨 (다시 살아남.)
     */
    History(),
    MyPage(),
    // NoticePage(),
  ];

  Future setAuthToken() async {
    SharedPreferences  pref = await SharedPreferences.getInstance();
    String token = pref.get("access_token").toString();
    String reToken = pref.get("refresh_token").toString();
    print("token : $token");
    print("reToken : $reToken");
    if (token != null && token != "" && reToken != null && reToken != "") {
      await Provider.of<UserProvider>(context, listen: false)
          .refreshToken(reToken);
      await Provider.of<UserProvider>(context, listen: false)
          .setAccessToken(token);
      await Provider.of<BannerProvider>(context, listen: false).getBanners();
      try{
        await Provider.of<ProductProvider>(context, listen: false).changeUserPosition(
          Provider.of<UserProvider>(context, listen: false).userLocationLatitude,
          Provider.of<UserProvider>(context, listen: false).userLocationLongitude,
        );
      }
      catch(e){
        await Provider.of<ProductProvider>(context, listen: false).changeUserPosition(
          Provider.of<UserProvider>(context, listen: false).defaultUserLocationLatitude,
          Provider.of<UserProvider>(context, listen: false).defaultUserLocationLongitude,
        );
      }

    } else {
      return;
    }
  }

  void onItemTapped(int index) {

    setState(() {
      if (index == 0) {
        bottomSelectedIndex = index;
        return;
      }
      if (index == 1) {
        if (!Provider.of<UserProvider>(context, listen: false).isLoggenIn) {
          _showDialog(context);
        } else {
          showModalBottomSheet(context: context, builder: buildBottomSheet, backgroundColor: Colors.transparent);
        }
      }
      if (index == 2) {
        if (!Provider.of<UserProvider>(context, listen: false).isLoggenIn) {
          _showDialog(context);
        } else {
          bottomSelectedIndex = index;
          return;
        }
      }
      if (index == 3) {
        bottomSelectedIndex = index;
        return;
      }
      // showModalBottomSheet(context: context, builder: buildBottomSheet);
    });
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle optionStyle =
        TextStyle(fontSize: 12, fontWeight: FontWeight.w400);

    return Consumer<UserProvider>(builder: (_, user, __) {
      return WillPopScope(
        onWillPop: () {
          if (bottomSelectedIndex != 0) {
            setState(() {
              bottomSelectedIndex = 0;
            });
            return Future(() => false);
          }
          return Future(() => true);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          key: globalKey,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: _widgetOptions.elementAt(bottomSelectedIndex),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/icon/home.png"),
                    color: Color(0xff888888)),
                title: Text(
                  '홈',
                  style: optionStyle,
                ),
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/icon/write.png"),
                    color: Color(0xff888888)),
                title: Text(
                  '글쓰기',
                  style: optionStyle,
                ),
              ),
              /**
               * NOTICE : 계약 기능 및 채팅 기능이 삭제됨 (다시 살아남)
               */
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/icon/list.png"),
                    color: Color(0xff888888)),
                title: Text(
                  '이용내역',
                  style: optionStyle,
                ),
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/icon/my.png"),
                    color: Color(0xff888888)),
                title: Text(
                  '마이페이지',
                  style: optionStyle,
                ),
              ),
            ],

            currentIndex: bottomSelectedIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Color(0xff888888),
            onTap: onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
          ),
        ),
      );
    });
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
          )
        ),
        child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    PageTransitioned(
                      child: ProductApplyPage(),
                      curves: Curves.fastOutSlowIn,
                      duration: const Duration(milliseconds: 500),
                      durationRev: const Duration(milliseconds: 600),
                    )
                );
              },
              child: SizedBox(
                height: 72.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.note_add),
                      SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "공유 물건 등록",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff333333)),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "가지고계신 물건 어떤 것이든 공유할 수 있어요.",
                            style: TextStyle(
                                fontSize: 12.sp, color: Color(0xff999999)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    PageTransitioned(
                      child: ProductReg(),
                      curves: Curves.fastOutSlowIn,
                      duration: const Duration(milliseconds: 500),
                      durationRev: const Duration(milliseconds: 600),
                    )
                );
              },
              child: SizedBox(
                height: 45.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.note_add),
                      SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "공유 물건 요청",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff333333)),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "필요하신 물건의 공유를 요청해보세요.",
                            style: TextStyle(
                                fontSize: 12.sp, color: Color(0xff999999)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    PageTransitioned(
                      child: ProductHelpReg(),
                      curves: Curves.fastOutSlowIn,
                      duration: const Duration(milliseconds: 500),
                      durationRev: const Duration(milliseconds: 600),
                    )
                );
              },
              child: SizedBox(
                height: 72.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.note_add),
                      SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "도와드려요",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff333333)),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "도와주고 싶다면 여기서 신청해보세요!",
                            style: TextStyle(
                                fontSize: 12.sp, color: Color(0xff999999)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )));
  }

  void _showDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(dialogChild(), "확인", () {
            Navigator.of(context).pop();
            setState(() {
              bottomSelectedIndex = 3;
            });
          });
        });
  }

  Widget dialogChild() {
    return Column(
      children: [
        Text(
          "로그인이 필요합니다.",
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xff333333)),
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }

  getPopUp(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? myTimestamp = pref.getInt("timestamp") ?? 0.toInt();

    if (myTimestamp == null || myTimestamp == 0) {
      showDialog(
          context: context,
          builder: (_) => CustomPopup(),
          barrierDismissible: false);
      return;
    }

    DateTime myDateTime = DateTime.fromMillisecondsSinceEpoch(myTimestamp);
    DateTime now = DateTime.now();

    Duration timeDifference = now.difference(myDateTime);

    if (timeDifference.inDays >= 1) {
      showDialog(
          context: context,
          builder: (_) => CustomPopup(),
          barrierDismissible: false);
    }
  }

  void _showDialogErr(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApply(Center(child: Text(text)), '확인');
        });
  }

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    Future.delayed(Duration.zero, () async {
      await Provider.of<FCMModel>(context, listen: false).getMbToken();
      await Provider.of<UserProvider>(context, listen: false).AddFCMtoken(Provider.of<FCMModel>(context, listen: false).mbToken!);
      bool getBanners = await Provider.of<BannerProvider>(context, listen: false).getBanners();
      await Provider.of<UserProvider>(context, listen: false).initialUserLocation();
      if(getBanners == false){
        _showDialogErr("서버와의 통신에 문제가 있습니다\n만약 서비스가 계속 작동되지 않는다면 고객센터로 문의 주십시오.");
      }
    });

    Provider.of<ProductProvider>(context, listen: false).getGeolocator();
    // if(Provider.of<UserProvider>(context, listen: false).userLocationX == 37.0 && Provider.of<UserProvider>(context, listen: false).userLocationY == 126){
    //
    // }
    if (Provider.of<UserProvider>(context, listen: false).isLoggenIn) {
      Provider.of<UserProvider>(context, listen: false).me();
    }

    keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: ${visible}');
      if (visible)
        showOverlay(context);
      else
        removeOverlay();
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      pref = await SharedPreferences.getInstance();
      setAuthToken();
    });
    getPopUp(context);
    // firebaseCloudMessaging_Listeners();
  }

  showOverlay(BuildContext context) {
    if (overlayEntry == null) return;
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        right: 10.0,
        child: InputDoneView(),
      );
    });
    overlayState!.insert(overlayEntry!);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
    }
  }

  Widget buildSetAddressBottomSheet(BuildContext context) {
    TextStyle titleStyle = TextStyle(
        fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black);

    TextStyle descriptionStyle = TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.normal,
        color: Color(0xff999999));

    TextStyle buttonStyle = TextStyle(
        fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white);
    return SafeArea(
      child: Container(
        height: 148,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "쌩유의 즐거움을 느껴보세요!",
                style: titleStyle,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "쌩유의 모든 서비스를 이용하실려면 위치등록이 필수입니다.",
                style: descriptionStyle,
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "위치등록 하러가기",
                      style: buttonStyle,
                    ),
                    onPressed: () async {
                      // Geolocator geolocator = Geolocator()
                      //   ..forceAndroidLocationManager = true;
                      print('위치 등록 시작 토큰 저장');
                      // geolocator
                      //     .getCurrentPosition(
                      //         desiredAccuracy: LocationAccuracy.best)
                      //     .then((Position position) {
                      //   print("${position.latitude}, ${position.longitude}");

                      // pref.setString("address",
                      //     "${position.latitude}, ${position.longitude}");
                      print("===================================");
                      Navigator.pop(context);
                      print("===================================");
                      // }).catchError((e) {
                      //   print('위치 저장 에러');
                      //   print("location exception: $e");
                      //   Navigator.pop(context);
                      // });
                      // Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
                      // print(position.latitude);
                      // print(position.longitude);
                      Navigator.pop(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

}
