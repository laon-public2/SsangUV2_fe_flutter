import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:convert';

class BaseClient extends http.BaseClient {
  final http.Client _client = http.Client();
//  String defaultUrl = "http://192.168.100.216:9881";

  // String defaultUrl = "http://158.247.215.222:9881";
  // String defaultUrl = "http://192.168.100.216:8090";
  // String authUrl = "http://192.168.100.216:8095";

  String defaultUrl = "http://192.168.100.232:5000/api";
  String authUrl = "http://192.168.100.232:5000/api";

  Map<String, String> _defaultHeaders = {};

  static final BaseClient _instance = BaseClient._internal();

  factory BaseClient() {
    return _instance;
  }

  BaseClient._internal() {
    _defaultHeaders['content-type'] = "application/json";
    print("init BaseClient");
  }

  setToken(String token) {
    // _defaultHeaders["X-AUTH-TOKEN"] = token;
    _defaultHeaders["Authorization"] = "Bearer " + token;
  }

  delToken() {
    _defaultHeaders.clear();
    _defaultHeaders['content-type'] = "application/json";
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request);
  }

  // @override
  // Future<http.Response> get(url, {Map<String, String>? headers}) {
  //   _client.get(Uri.parse(defaultUrl + url.toString()), headers: _defaultHeaders);
  // }

  @override
  Future<http.Response> post(url,
      {Map<String, String>? headers, dynamic body, Encoding? encoding}) {
    return _client.post(Uri.parse(defaultUrl + url.toString()),
        headers: _defaultHeaders, body: jsonEncode(body), encoding: encoding);
  }

  @override
  Future<http.Response> patch(url,
      {Map<String, String>? headers, dynamic body, Encoding? encoding}) {
    return _client.patch(Uri.parse(defaultUrl + url.toString()),
        headers: _defaultHeaders, body: jsonEncode(body), encoding: encoding);
  }

  @override
  Future<http.Response> put(url,
      {Map<String, String>? headers, dynamic body, Encoding? encoding}) {
    return _client.put(Uri.parse(defaultUrl + url.toString()),
        headers: _defaultHeaders, body: jsonEncode(body), encoding: encoding);
  }

  @override
  Future<http.Response> head(url, {Map<String, String>? headers}) {
    return _client.head(Uri.parse(defaultUrl + url.toString()), headers: _defaultHeaders);
  }

  // @override
  // Future<http.Response> delete(url, {Map<String, String>? headers}) {
  //   return _client.delete(Uri.parse(defaultUrl + url.toString()), headers: _defaultHeaders);
  // }

  Future<http.Response> auth(url,
      {Map<String, String>? headers, dynamic body, Encoding? encoding}) {
    print("asdasd " + authUrl + url);
    return _client.post(Uri.parse(authUrl + url), headers: _defaultHeaders);
  }

  Future<http.Response> postWithParam(url, {Map<String, String>? headers}) {
    return _client.post(Uri.parse(defaultUrl + url), headers: _defaultHeaders);
  }

  Future<http.StreamedResponse> updateProfile(url, File file) async {
    var uri = Uri.parse(defaultUrl + url);
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('profile', file.path));
    request.headers.addAll(_defaultHeaders);
    var response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> uploadImage(
      int orderId, String url, Uint8List imageData) async {
    var uri = Uri.parse(defaultUrl + url);
    var request = http.MultipartRequest('POST', uri);
    http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
      'image',
      imageData,
      filename: '${orderId}-${DateTime.now().millisecondsSinceEpoch}',
    );
    request.files.add(multipartFile);
    request.headers.addAll(_defaultHeaders);
    var response = await request.send();
    return response;
  }
}
