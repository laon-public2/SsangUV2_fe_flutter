
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' hide WebView;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_product_v2/model/KopoModel.dart';
import 'dart:convert';

export 'package:share_product_v2/model/KopoModel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KakaoMap extends StatefulWidget {
  static const String PATH = '/kopo';

  KakaoMap({
    Key key,
    this.title = '주소검색',
    this.colour = Colors.white,
    this.apiKey = '',
  }) : super(key: key);

  @override
  KakaoMapState createState() => KakaoMapState();

  final String title;
  final Color colour;
  final String apiKey;
}

final assetPath = "lib/assets/daum_search.html";

class KakaoMapState extends State<KakaoMap> {

  WebViewController _controller;
  WebViewController get controller => _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.colour,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData().copyWith(color: Colors.black),
      ),
      body: WebView(
          initialUrl: "http://localhost:8080/$assetPath",
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: Set.from([

            JavascriptChannel(
                name: 'messageHandler',
                onMessageReceived: (JavascriptMessage message) {
                  //This is where you receive message from
                  //javascript code and handle in Flutter/Dart
                  //like here, the message is just being printed
                  //in Run/LogCat window of android studio
                  Navigator.pop(
                      context, KopoModel.fromJson(jsonDecode(message.message)));
                }),
          ]),
          onWebViewCreated: (WebViewController webViewController) async {
            _controller = webViewController;
          }),
    );
  }
}
