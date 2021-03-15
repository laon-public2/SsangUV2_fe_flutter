import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/model/StompSendDTO.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../product/ProductDetail.dart';

const String _name = "SampleName";
const String _date = "02/02 02:02";

class CustomerMessage extends StatefulWidget {
  final String title;
  final int productIdx;
  final String uuid;
  final String status;

  CustomerMessage(this.uuid, this.productIdx, this.title, this.status);

  @override
  _CustomerMessage createState() => _CustomerMessage();
}

class _CustomerMessage extends State<CustomerMessage>
    with TickerProviderStateMixin {
  // File _image;
  StompClient client;
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  Future<void> setClient() {
    client = StompClient(
      config: StompConfig(
        url: "ws://115.91.73.66:11111/ws-stomp/websocket",
        onConnect: (StompClient _client, StompFrame connectFrame) async {
          print("채팅방 connect ${_client.connected}");
          _client.subscribe(
            destination: '/sub/chat/rooms/${this.widget.uuid}',
            callback: (StompFrame frame) {
              print("frameBody: ${frame.body}");
              List<dynamic> result = json.decode(frame.body);
              print(result);
            },
          );
        },
        onStompError: (error) => print("stompError : ${error.body}"),
        onWebSocketError: (error) => print("error : ${error.toString()}"),
      ),
    );
    client.activate();
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
    // TODO: implement initState
    super.initState();
    print("채팅방 입장");
    print("uuid : ${this.widget.uuid}");
    _talking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              leading:
                  Container(width: 50, height: 50, color: Colors.grey[500]),
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '[사성 오피스] 사무실 대여 (누구나 대여)',
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
                    'laonstory',
                    style: TextStyle(
                      color: Color(0xff999999),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '500,000원 / 일',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff444444),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetail()),
                );
              },
            ),
          ),
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          SizedBox(height: 5),
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
            // onTap: () {

            // },
          ),
          SizedBox(height: 5),
          Divider(height: 1.0),
          Container(
            child: _buildTextComposer(),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
          ),
        ],
      ),
    );
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
                // onPressed: () {
                //   getGalleryImage() async {
                //     var image = await ImagePicker.pickImage(
                //         source: ImageSource.gallery);
                //     setState(() {
                //       _image = image as File;
                //     });
                //   }
                // },
                onPressed: () {},
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

  void _handleSubmitted(String text) {
    _sendMsg(text);
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = ChatMessage(
      text: text,
      // animationController: AnimationController(
      //     duration: Duration(milliseconds: 400), vsync: this),
    );
    setState(() {
      _messages.insert(0, message);
    });
    // message.animationController.forward();
  }

  _appBar() {
    return AppBar(
      centerTitle: true,
      elevation: 1.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 30.0,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        this.widget.title,
        style: TextStyle(
          color: Color(0xff444444),
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text});

  final String text;

  // final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "$_date",
              style: TextStyle(
                fontSize: 13.sp,
                color: Color(0xff666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
