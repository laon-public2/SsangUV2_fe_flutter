import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/model/StompSendDTO.dart';
import 'package:share_product_v2/pages/product/ProductDetailRent.dart';
import 'package:share_product_v2/providers/contractProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../../providers/userProvider.dart';
import '../product/ProductDetail.dart';

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

  // final String status; 이건 왜넣었는지 나도 모르겠음.. 필요하면
  //여기 아래에 필요한 파리미터 적어서 필요한 곳에 넣어서 잘 쓰면 됨.
  CustomerMessage(this.uuid, this.productIdx, this.title, this.category,
      this.productOwner, this.price, this.pic);

  @override
  _CustomerMessage createState() => _CustomerMessage();
}

class _CustomerMessage extends State<CustomerMessage>
    with TickerProviderStateMixin {
  Map<String, String> headers;
  int page = 0;
  final picker = ImagePicker();
  List<Asset> images = List<Asset>();
  bool _imageView = false;

  ScrollController bottomScrollController = ScrollController();
  ScrollController chatScrollController = ScrollController();

  //사진 선택
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
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
        onStompError: (error) => print("stompError : ${error.body}"),
        onWebSocketError: (error) => print("error : ${error.toString()}"),
      ),
    );
    client.activate();
    return null;
  }

  _sendMsg(String text) {
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
  }

  _talking() async {
    await setClient();
  }

  @override
  void initState() {
    super.initState();
    print("채팅방 입장");
    print("uuid : ${this.widget.uuid}");
    _talking();
    bottomScrollController.addListener(_scrollerListener);
  }

  void dispose() {
    _textController.dispose();
    if (client != null) client.deactivate();
    super.dispose();
  }

  Future<bool> _loadChat() async {
    final cvm = Provider.of<ContractProvider>(context, listen: false);
    await cvm.getChatHistory(this.widget.uuid, this.page);
    return true;
  }

  _scrollerListener() async {
    final cvm = Provider.of<ContractProvider>(context, listen: false);
    if (bottomScrollController.position.minScrollExtent ==
            bottomScrollController.offset &&
        cvm.chatHistories.length > cvm.chatHistoriesCounter.totalCount) {
      setState(() {
        this.page += 1;
      });
      await cvm.getChatHistory(this.widget.uuid, page);
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
                                SizedBox(height: 50),
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
                                child: Image.network(
                                  "http://192.168.100.232:5066/assets/images/product/${this.widget.pic}",
                                  fit: BoxFit.cover,
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
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: 70,
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Container(
                                width: 120.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                    color: Color(0xffff0066),
                                    borderRadius: BorderRadius.circular(40)),
                                child: Center(
                                  child: Text(
                                    '대여시작',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    //이미지 박스
                    _imageView ?
                    images.length != 0
                        ? Positioned(
                            left: 8,
                            right: 8,
                            bottom: 10,
                            child: Container(
                              width: double.infinity,
                              height: 150.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    color:
                                    Color.fromRGBO(0, 0, 0, 0.15),
                                    blurRadius: 8.0,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: photoApply(),
                                ),
                              ),
                            ),
                          )
                        : SizedBox():SizedBox(),
                    //이미지 박스 닫기 버튼
                    _imageView ?
                    images.length != 0
                        ? Positioned(
                          bottom: 160,
                          left: 8,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    this._imageView = false;
                                  });
                                },
                                child: Container(
                                  width: 80.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                      color: Color(0xffff0066),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0,2),
                                            color: Color.fromRGBO(0, 0, 0, 0.15),
                                            blurRadius: 8.0
                                        ),
                                      ]
                                  ),
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
                                onTap: () {
                                  setState(() {
                                    this._imageView = false;
                                  });
                                },
                                child: Container(
                                  width: 80.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                      color: Color(0xff046582),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0,2),
                                            color: Color.fromRGBO(0, 0, 0, 0.15),
                                            blurRadius: 8.0
                                        ),
                                      ]
                                  ),
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
                          )
                        )
                        :SizedBox():SizedBox(),
                    //이미지 보내기 버튼
                  ],
                ),
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
        height: defaultTargetPlatform == TargetPlatform.iOS ? 90 : null,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
              child: IconButton(
                icon: Image.asset('assets/icon/inputImg.png'),
                iconSize: 16,
                onPressed: () async {
                  setState(() {
                    this._imageView = true;
                  });
                  await loadAssets();
                },
                // onPressed: () {},
              ),
            ),
            Flexible(
              child: Container(
                height: defaultTargetPlatform == TargetPlatform.iOS ? 60 : 50,
                padding: const EdgeInsets.only(left: 7, bottom: 7, top: 7),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffebebeb),
                    border: Border.all(color: Color(0xffdddddd)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            controller: _textController,
                            onChanged: (String text) {
                              setState(() {
                                _isComposing = text.length > 0;
                              });
                            },
                            onSubmitted: _isComposing ? _handleSubmitted : null,
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
                            onPressed: _isComposing
                                ? () => _handleSubmitted(_textController.text)
                                : null,
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

  void _handleSubmitted(String text) async {
    setState(() {
      _isComposing = false;
    });
    await _sendMsg(text);
    _textController.clear();
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
    print("$sender, $text, $date, $type, $uuid");
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
                                child: Image.network(
                                  'http://115.91.73.66:11111/chat/resource/image?path=/${this.uuid}/${_imageDateFormat(this.date)}/',
                                  width: 200.w,
                                  fit: BoxFit.cover,
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
                        child: Text(
                          "$text",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Color(0xff666666),
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
