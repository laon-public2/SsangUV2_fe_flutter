import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/model/StompSendDTO.dart';
import 'package:share_product_v2/pages/product/ProductDetailRent.dart';
import 'package:share_product_v2/providers/contractProvider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/chatBigImg.dart';
import 'package:share_product_v2/widgets/loading.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '../../providers/userProvider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:connectivity/connectivity.dart';

const String _name = "SampleName";
const String _date = "02/02 02:02";

class CustomerMessage extends StatefulWidget {
  final String title;
  final int productIdx;
  final String uuid;
  final String category;
  final String productOwner;
  final int price;
  final String pic;
  String status;
  final int receiverIdx;
  final String senderFcm;
  final String receiverFcm;
  final int senderIdx;

  // final String status; 이건 왜넣었는지 나도 모르겠음.. 필요하면
  //여기 아래에 필요한 파리미터 적어서 필요한 곳에 넣어서 잘 쓰면 됨.
  CustomerMessage(this.uuid, this.productIdx, this.title, this.category,
      this.productOwner, this.price, this.pic, this.status, this.receiverIdx, this.senderFcm, this.receiverFcm, this.senderIdx);

  @override
  _CustomerMessage createState() => _CustomerMessage();
}

class _CustomerMessage extends State<CustomerMessage>
    with WidgetsBindingObserver, TickerProviderStateMixin{
  Map<String, String> headers;
  int page = 0;
  final picker = ImagePicker();
  List<Asset> images = [];
  bool _imageView = false;
  int imgQuality = 100;


  //스크롤 컨트롤러 애니메이션
  ScrollController bottomScrollController = ScrollController();
  ScrollController chatScrollController = ScrollController();

  //사진 선택
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 8,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#ff0066",
          actionBarTitle: "업로드할 사진 선택",
          actionBarTitleColor: "#ffffff",
          statusBarColor: '#ff0066',
          lightStatusBar: false,
          allViewTitle: "모든 사진",
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

  //사진 리스트
  Widget photoApply() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: images.map((e) {
              return Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: AssetThumb(
                    quality: 50,
                    asset: e,
                    width: 90,
                    height: 90,
                  ),
                ),
                Positioned(
                  top: -7,
                  right: -6,
                  child: IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        setState(() {
                          images.remove(e);
                        });
                      }),
                )
              ]);
            }).toList(),
          ),
        ],
      ),
    );
  }

  // File _image;
  StompClient client;
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  Future<void> setClient() {
    print(this.widget.uuid);
    //웹 소켓을 연결하기 위한 설정 코드
    client = StompClient(
      config: StompConfig(
        url: "ws://115.91.73.66:11111/ws-stomp/websocket",
        // websocket를 꼭 필수로 적어야 함.
        onConnect: (StompClient _client, StompFrame connectFrame) async {
          print(
              "채팅방 connect ${_client.connected} , /sub/chat/rooms/${this.widget.uuid}");
          _client.subscribe(
            destination: '/sub/chat/rooms/${this.widget.uuid}',
            callback: (frame) async {
              var jsonRes = json.decode(frame.body);
              print("frame.body : $jsonRes");
              StompSendDTO dto = StompSendDTO.fromJson(jsonRes);
              await Provider.of<ContractProvider>(context, listen: false)
                  .addChat(dto);
              double _position =
                  50.0 + bottomScrollController.position.maxScrollExtent;
              bottomScrollController.animateTo(
                _position,
                duration: Duration(milliseconds: 700),
                curve: Curves.ease,
              );
            },
          );
        },
        onStompError: (error) {
          print("stompError : ${error.body.toString()}");
          // Fluttertoast.showToast(
          //     msg: "네트워크 연결이 원할하지 않습니다.",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.BOTTOM,
          //     backgroundColor: Color(0xffff0066),
          //     textColor: Colors.white,
          //     fontSize: 16.0
          // );
        },
        onWebSocketError: (error) => print("error : ${error.toString()}"),
      ),
    );
    client.activate();
    return null;
  }

  _sendMsg(String text) {
    var user = Provider.of<UserProvider>(context, listen: false);
    StompSendDTO data = StompSendDTO(
      orderId: "${this.widget.uuid}",
      sender: Provider.of<UserProvider>(context, listen: false).username,
      content: _textController.text,
      type: "TEXT",
    );
    client.send(
      destination: '/pub/chat/message',
      body: json.encode(data.toJson()),
    );
    if(this.widget.senderIdx == user.userIdx){
      Provider.of<ContractProvider>(context, listen: false).sendFcm(
        this.widget.title,
        text,
        this.widget.productIdx,
        this.widget.uuid,
        _selectCategory(this.widget.category),
        this.widget.productOwner,
        this.widget.price,
        this.widget.status,
        this.widget.receiverIdx,
        this.widget.receiverFcm,
        this.widget.pic,
        this.widget.senderFcm,
        this.widget.receiverFcm,
        this.widget.senderIdx,
      );
    }else{
      Provider.of<ContractProvider>(context, listen: false).sendFcm(
        this.widget.title,
        text,
        this.widget.productIdx,
        this.widget.uuid,
        _selectCategory(this.widget.category),
        this.widget.productOwner,
        this.widget.price,
        this.widget.status,
        this.widget.receiverIdx,
        this.widget.senderFcm,
        this.widget.pic,
        this.widget.senderFcm,
        this.widget.receiverFcm,
        this.widget.senderIdx,
      );
    }

  }

  _talking() async {
    await setClient();
  }

  _selectCategory(String category) {
    if (category == "생활용품") {
      return 2;
    }
    if (category == "여행") {
      return 3;
    }
    if (category == "스포츠/레저") {
      return 4;
    }
    if (category == "육아") {
      return 5;
    }
    if (category == "반려동물") {
      return 6;
    }
    if (category == "가전제품") {
      return 7;
    }
    if (category == "의류/잡화") {
      return 8;
    }
    if (category == "가구/인테리어") {
      return 9;
    }
    if (category == "자동차용품") {
      return 10;
    }
    if (category == "기타") {
      return 11;
    }
  }

  chatScroller() async{
    final cvm = Provider.of<ContractProvider>(context, listen: false);
   if(bottomScrollController.position.pixels == bottomScrollController.position.minScrollExtent) {
     print("현재 채팅방의 스크롤이 가장 위에 위치하고 있습니다.");
     if(cvm.chatHistoriesCounter.totalCount != cvm.chatHistories.length){
       this.page++;
       await cvm.getChatHistory(this.widget.uuid, page);
     }
   }
  }
  //인터넷 연결 상태 작업
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connSub;

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try{
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch(e) {
      print(e.toString());
    }
    if(!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        print("와이파이 $result");
        // _talking();
        // _loadChat();
        Fluttertoast.showToast(
            msg: "대여하실때 물품상태를 확인해주세요!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xffff0066),
            textColor: Colors.white,
            fontSize: 16.0
        );
        break;
      case ConnectivityResult.mobile:
        print("모바일데이터 $result");
        // _talking();
        // _loadChat();
        Fluttertoast.showToast(
            msg: "대여하실때 물품상태를 확인해주세요!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xffff0066),
            textColor: Colors.white,
            fontSize: 16.0
        );
        break;
      case ConnectivityResult.none:
        if (client != null) client.deactivate();
        print("인터넷연결이 안됨 $result");
        Fluttertoast.showToast(
            msg: "네트워크 상태가 원할하지 않습니다.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xffff0066),
            textColor: Colors.white,
            fontSize: 16.0
        );
        break;
      default:
        if (client != null) client.deactivate();
        print("기본 $result");
        Fluttertoast.showToast(
            msg: "네트워크 상태가 원할하지 않습니다.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xffff0066),
            textColor: Colors.white,
            fontSize: 16.0
        );
        break;
    }
  }
  //여기까지

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    //인터넷 연결 상태
    initConnectivity();
    _connSub =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    //
    print("채팅방 입장");
    print("uuid : ${this.widget.uuid}");
    _talking();
    bottomScrollController.addListener(_scrollerListener);
    bottomScrollController.addListener(chatScroller);
    KeyboardVisibility.onChange.listen((bool visible) {
      print('키보드 상태가 업데이트 되었습니다. Is visible: ${visible}');
      if (visible){
        print("키보드가 올라와 있습니다.");
        double _position =  500.0 + bottomScrollController.position.maxScrollExtent;
        bottomScrollController.animateTo(
          _position,
          duration: Duration(milliseconds: 700),
          curve: Curves.ease,
        );
      }
      else
        print("키보드가 내려갔습니다.");
    });
  }

  void dispose() {
    _textController.dispose();
    bottomScrollController.dispose();
    //채팅방 연결 해제
    if (client != null) client.deactivate();
    WidgetsBinding.instance.addObserver(this);
    //연결 해제
    _connSub.cancel();
    super.dispose();
  }

  Future<bool> _loadChat() async {
    final cvm = Provider.of<ContractProvider>(context, listen: false);
    await cvm.getChatHistory(this.widget.uuid, this.page);
    return true;
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return null;
    await _sendMsg(text);
    _textController.clear();
  }

  _scrollerListener() async {
    // final cvm = Provider.of<ContractProvider>(context, listen: false);
    // if (bottomScrollController.position.minScrollExtent ==
    //         bottomScrollController.offset &&
    //     cvm.chatHistories.length > cvm.chatHistoriesCounter.totalCount) {
    //   setState(() {
    //     this.page += 1;
    //   });
    //   await cvm.getChatHistory(this.widget.uuid, page);
    // }
  }

  void didChangeAppLifeCycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.resumed:
        print("앱이 Resumed된 상태입니다.");
        break;
      case AppLifecycleState.inactive:
        print("앱이 Inactive된 상태입니다.");
        break;
      case AppLifecycleState.paused:
        print("앱이 백그라운드로 돌아가며 Paused된 상태입니다.");
        break;
      case AppLifecycleState.detached:
        print("앱이 여전히 돌아가지만 호스트 view에서 분리됩니다. detached상태");
        break;
    }
  }

  chatStatus(String status) {
    switch(status) {
      case "INIT":
        return "대여시작";
        break;
      case "START" :
        return "대여종료";
        break;
      case "FINISH" :
        return "대여종료됨";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: FutureBuilder(
          future: _loadChat(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return Container(
                height: 300.h,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xffff0066)),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error ${snapshot.hasError}',
                  style: TextStyle(fontSize: 15),
                ),
              );
            } else {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                if (bottomScrollController.hasClients) {
                  double _position =
                      50.0 + bottomScrollController.position.maxScrollExtent;
                  bottomScrollController.animateTo(
                    _position,
                    duration: Duration(milliseconds: 700),
                    curve: Curves.ease,
                  );
                }
              });
              return Consumer<UserProvider>(
                builder: (_, _user, __){
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            padding: const EdgeInsets.only(bottom: 57),
                            child: Container(
                              child: SingleChildScrollView(
                                controller: bottomScrollController,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 80.h),
                                    Consumer<ContractProvider>(
                                      builder: (_, chat, __) {
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            controller: chatScrollController,
                                            padding: const EdgeInsets.all(8.0),
                                            reverse: true,
                                            itemBuilder: (context, idx) {
                                              return ChatMessage(
                                                text: chat.chatHistories[idx].content,
                                                date:
                                                chat.chatHistories[idx].createAt,
                                                sender:
                                                chat.chatHistories[idx].sender,
                                                type: chat.chatHistories[idx].type,
                                                uuid: this.widget.uuid,
                                              );
                                            },
                                            itemCount: chat.chatHistories.length,
                                          );
                                      },
                                    ),
                                    SizedBox(height: defaultTargetPlatform == TargetPlatform.iOS ? 90 : 50),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 2),
                                  color: Color.fromRGBO(0, 0, 0, 0.15),
                                  blurRadius: 8.0,
                                ),
                              ],
                            ),
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff).withOpacity(.4),
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    child: ExtendedImage.network(
                                      "http://115.91.73.66:15066/assets/images/product/${this.widget.pic}",
                                      fit: BoxFit.cover,
                                      cache: true,
                                      borderRadius: BorderRadius.circular(5),
                                      loadStateChanged: (ExtendedImageState state) {
                                        switch(state.extendedImageLoadState) {
                                          case LoadState.loading :
                                            return Image.asset(
                                              "assets/loadingIcon.gif",
                                              fit: BoxFit.fill,
                                            );
                                            break;
                                          case LoadState.completed :
                                            break;
                                          case LoadState.failed :
                                            return GestureDetector(
                                              child: Image.asset(
                                                "assets/icon/icons8-cloud-refresh-96.png",
                                                fit: BoxFit.fill,
                                              ),
                                              onTap: () {
                                                state.reLoadImage();
                                              },
                                            );
                                            break;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                title: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        '${this.widget.title}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff444444),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${this.widget.productOwner}',
                                      style: TextStyle(
                                        color: Color(0xff999999),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${_moneyFormat("${this.widget.price}")}원 / 일',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff444444),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  client.deactivate();
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: ProductDetailRent(
                                        this.widget.productIdx,
                                        this.widget.category,
                                      ),
                                      type: PageTransitionType.rightToLeft,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: double.infinity,
                            height: 60.h,
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Divider(height: 1.0),
                                _buildTextComposer(),
                              ],
                            ),
                          ),
                        ),
                        this.widget.productOwner == _user.username ?
                        Positioned(
                          right: 0,
                          left: 0,
                          bottom: defaultTargetPlatform == TargetPlatform.iOS ? 90 : 70,
                          child: Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Consumer<ProductProvider>(
                                  builder: (_, _product, __){
                                    return InkWell(
                                      child: Container(
                                        width: 120.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                            color: this.widget.status != "FINISH" ? Color(0xffff0066) : Color(0xffc4c4c4),
                                            borderRadius: BorderRadius.circular(40)),
                                        child: Center(
                                          child: Text(
                                            '${chatStatus(this.widget.status)}',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () async{
                                        if(this.widget.status == "FINISH") {
                                          return null;
                                        }else{
                                          await _product.rentStatus(
                                            Provider.of<UserProvider>(context, listen: false).accessToken,
                                            Provider.of<UserProvider>(context, listen: false).userIdx,
                                            this.widget.receiverIdx,
                                            this.widget.productIdx,
                                            this.widget.status,
                                            this.widget.uuid,
                                          );
                                          if(this.widget.status == "INIT"){
                                            setState(() {
                                              this.widget.status = "START";
                                            });
                                          }else if(this.widget.status == "START"){
                                            setState(() {
                                              this.widget.status = "FINISH";
                                            });
                                          }
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ):SizedBox(),
                        //이미지 박스
                        _imageView
                            ? images.length != 0
                            ? Positioned(
                          left: 8,
                          right: 8,
                          bottom: 10,
                          child: Container(
                            width: double.infinity,
                            height: 150.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 2),
                                  color: Color.fromRGBO(0, 0, 0, 0.15),
                                  blurRadius: 8.0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10),
                                child: photoApply(),
                              ),
                            ),
                          ),
                        )
                            : SizedBox()
                            : SizedBox(),
                        //이미지 박스 닫기 버튼
                        _imageView
                            ? images.length != 0
                            ? Positioned(
                            bottom: 160.h,
                            left: 8,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      this._imageView = false;
                                      this.images = [];
                                    });
                                  },
                                  child: Container(
                                    width: 80.w,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                        color: Color(0xffff0066),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 2),
                                              color: Color.fromRGBO(
                                                  0, 0, 0, 0.15),
                                              blurRadius: 8.0),
                                        ]),
                                    child: Center(
                                      child: Text(
                                        '닫기',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      this._imageView = false;
                                    });
                                    showDialog(
                                        context: context,
                                        barrierColor:
                                        Colors.black.withOpacity(0.0),
                                        builder: (BuildContext context) {
                                          return Loading();
                                        });
                                    await Provider.of<ContractProvider>(
                                        context,
                                        listen: false)
                                        .uploadImage(
                                      images,
                                      this.widget.uuid,
                                      Provider.of<UserProvider>(context,
                                          listen: false)
                                          .username,
                                    );
                                    setState(() {
                                      this.images = [];
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 80.w,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                        color: Color(0xff046582),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 2),
                                              color: Color.fromRGBO(
                                                  0, 0, 0, 0.15),
                                              blurRadius: 8.0),
                                        ]),
                                    child: Center(
                                      child: Text(
                                        '보내기',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ))
                            : SizedBox()
                            : SizedBox(),
                        //이미지 보내기 버튼
                      ],
                    ),
                  );
                },
              );
            }
          },
        ));
  }

  _moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        // height: defaultTargetPlatform == TargetPlatform.iOS ? 70 : null,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        constraints: BoxConstraints(
          maxHeight: 300.0,
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: defaultTargetPlatform == TargetPlatform.iOS ? 40 : 40,
              height: defaultTargetPlatform == TargetPlatform.iOS ? 40 : 40,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Color(0xffdddddd)),
              ),
              child: Consumer<ContractProvider>(
                builder: (_, _contract, __) {
                  return IconButton(
                    icon: Image.asset('assets/icon/inputImg.png'),
                    iconSize: 16,
                    onPressed: () async {
                      setState(() {
                        this._imageView = true;
                      });
                      await loadAssets();
                    },
                  );
                },
              ),
            ),
            Flexible(
              child: Container(
                height: defaultTargetPlatform == TargetPlatform.iOS ? 55 : 50,
                padding: const EdgeInsets.only(left: 7, bottom: 7, top: 7),
                constraints: BoxConstraints(
                  maxHeight: 300.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffebebeb),
                    border: Border.all(color: Color(0xffdddddd)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: 300.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            controller: _textController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            minLines: 1,
                            onSubmitted: _handleSubmitted,
                            decoration: InputDecoration.collapsed(
                              hintText: "",
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: defaultTargetPlatform == TargetPlatform.iOS
                            ? EdgeInsets.only(right: 5)
                            : EdgeInsets.only(right: 2),
                        child: Container(
                          width: defaultTargetPlatform == TargetPlatform.iOS
                              ? 35
                              : 30,
                          height: defaultTargetPlatform == TargetPlatform.iOS
                              ? 35
                              : 30,
                          decoration: BoxDecoration(
                            color: Color(0xffff0066),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            icon: Image.asset('assets/icon/send.png'),
                            color: Colors.white,
                            iconSize: 16,
                            onPressed: () =>
                                _handleSubmitted(_textController.text),
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
      ),
    );
  }

  _appBar() {
    return AppBar(
      centerTitle: true,
      elevation: 1.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 25.sp,
        ),
        onPressed: () {
          client.deactivate();
          Navigator.pop(context);
        },
      ),
      title: Text(
        this.widget.title,
        style: TextStyle(
          color: Color(0xff444444),
          fontSize: 17.sp,
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.date, this.sender, this.type, this.uuid});

  final String sender;
  final String text;
  final String date;
  final String type;
  final String uuid;
  // final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    // print("$sender, $text, $date, $type, $uuid");
    return Consumer<UserProvider>(
      builder: (_, _user, __) {
        return _user.username == sender
            ? ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: double.infinity,
                        ),
                        child: this.type == "TEXT"
                            ? Text(
                                this.text == null ? "null오류입니다." : "$text",
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Color(0xff666666),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  width: 200.w,
                                  height: 200.h,
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          barrierColor:
                                          Colors.black.withOpacity(0.0),
                                          builder: (BuildContext context) {
                                            return ChatBigImg(this.text);
                                          });
                                    },
                                    child: ExtendedImage.network(
                                      "http://115.91.73.66:11111/chat/resource/image?path=${this.text}",
                                      fit: BoxFit.cover,
                                      cache: true,
                                      borderRadius: BorderRadius.circular(5),
                                      loadStateChanged: (ExtendedImageState state) {
                                        switch(state.extendedImageLoadState) {
                                          case LoadState.loading :
                                            return Image.asset(
                                              "assets/loadingIcon.gif",
                                              width: 20.w,
                                              height: 20.h,
                                            );
                                            break;
                                          case LoadState.completed :
                                            break;
                                          case LoadState.failed :
                                            return GestureDetector(
                                              child: Image.asset(
                                                "assets/icon/icons8-cloud-refresh-96.png",
                                                fit: BoxFit.fill,
                                              ),
                                              onTap: () {
                                                state.reLoadImage();
                                              },
                                            );
                                            break;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        this.date == null
                            ? "null오류입니다."
                            : "${_dateFormat(date)}",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Color(0xff666666),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: double.infinity,
                        ),
                        child: this.type == "TEXT"
                            ? Text(
                          this.text == null ? "null오류입니다." : "$text",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Color(0xff666666),
                          ),
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            width: 200.w,
                            height: 200.h,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierColor:
                                    Colors.black.withOpacity(0.0),
                                    builder: (BuildContext context) {
                                      return ChatBigImg(this.text);
                                    });
                              },
                              child: ExtendedImage.network(
                                "http://115.91.73.66:11111/chat/resource/image?path=${this.text}",
                                fit: BoxFit.cover,
                                cache: true,
                                borderRadius: BorderRadius.circular(5),
                                loadStateChanged: (ExtendedImageState state) {
                                  switch(state.extendedImageLoadState) {
                                    case LoadState.loading :
                                      return Image.asset(
                                        "assets/loadingIcon.gif",
                                        width: 20.w,
                                        height: 20.h,
                                      );
                                      break;
                                    case LoadState.completed :
                                      break;
                                    case LoadState.failed :
                                      return GestureDetector(
                                        child: Image.asset(
                                          "assets/icon/icons8-cloud-refresh-96.png",
                                          fit: BoxFit.fill,
                                        ),
                                        onTap: () {
                                          state.reLoadImage();
                                        },
                                      );
                                      break;
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${_dateFormat(date)}",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Color(0xff666666),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  _dateFormat(String date) {
    String formatDate(DateTime date) =>
        new DateFormat("MM/dd hh:mm").format(date);
    return formatDate(DateTime.parse(date));
  }

  _imageDateFormat(String date) {
    String formatDate(DateTime date) =>
        new DateFormat("yyyy-MM-dd").format(date);
    return formatDate(DateTime.parse(date));
  }
}
