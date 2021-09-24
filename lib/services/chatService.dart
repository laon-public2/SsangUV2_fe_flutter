import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChattingService {
  var dio = Dio();

  Future<Response?> getChatList(String uuid) async {
    print('이전 채팅기록내역');
  }
}
