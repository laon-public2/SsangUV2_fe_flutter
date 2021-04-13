import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_product_v2/widgets/loading.dart';
import 'package:http/http.dart' as http;

// final String SERVER_ADDRESS = "ssangu.oig.kr"; 오리지널
final String SERVER_ADDRESS = "115.91.73.66";
// final String SERVER_ADDRESS = "192.168.100.232";
final String chat_address = "115.91.73.66";

final String SERVERURL = "http://${SERVER_ADDRESS}:15000/api";
final String CHATSERVERURL = "http://${chat_address}:11111";
final String AUTHSERVERURL = "http://${SERVER_ADDRESS}:15000/api";

GlobalKey globalKey;

bool isLoading = false;

class ApiUtils {
  Dio dio;

  ApiUtils() {
    globalKey = new GlobalKey();
    dio = new Dio();
    dio.options.baseUrl = SERVERURL;
    // dio
    //   ..interceptors.add(InterceptorsWrapper(
    //       onRequest: (RequestOptions options) => requestInterceptor(options),
    //       onResponse: (Response response) => responseInterceptor(response)));
    // onError: (DioError error) => errorInterceptor(error)));
  }
  static ApiUtils instance = ApiUtils();
}

class ChatUtils {
  Dio dio;
  ChatUtils() {
    globalKey = new GlobalKey();
    dio = new Dio();
    dio.options.baseUrl = CHATSERVERURL;
    // dio
    //   ..interceptors.add(InterceptorsWrapper(
    //       onRequest: (RequestOptions options) => requestInterceptor(options),
    //       onResponse: (Response response) => responseInterceptor(response)));
  }
  static ChatUtils instance = ChatUtils();
}


class AuthUtils {
  Dio dio;

  AuthUtils() {
    dio = new Dio();
    dio.options.baseUrl = AUTHSERVERURL;
  }

  void setToken(String token) {
    dio.options.headers['Authorization'] = "Bearer $token";
  }

  static AuthUtils instance = AuthUtils();
}

class ChatServerUtils {
  Dio dio;

  ChatServerUtils() {
    dio = new Dio();
    dio.options.baseUrl = CHATSERVERURL;
  }

  void setToken(String token) {
    dio.options.headers['Authorization'] = "Bearer $token";
  }

  static ChatServerUtils instance = ChatServerUtils();
}

dynamic requestInterceptor(RequestOptions options) async {
  print("request isloading: $isLoading");
  print("options.path : ${options.path}");
  String path = options.path;
  if (path == "/banners" || path == "/products/special") return;

  if (!isLoading) {
    print("loading show");
    isLoading = true;
    showDialog(
        context: globalKey.currentContext,
        barrierColor: Colors.black.withOpacity(0.0),
        builder: (BuildContext context) {
          return Loading();
        });
  }
}

dynamic responseInterceptor(Response options) async {
  print("response isloading: $isLoading");
  if (isLoading) {
    isLoading = false;
    print("loading show false");
    Navigator.of(globalKey.currentContext).pop();
  }
}

// dynamic errorInterceptor(DioError dioError) {
//   print("dioError ${dioError}");
//   // if (dioError.response.statusCode == 401) {
//   //   Navigator.of(globalKey.currentContext)
//   //       .push(_createLoginRoute())
//   //       .then((value) {
//   //     UserProvider user =
//   //         Provider.of<UserProvider>(globalKey.currentContext, listen: false);
//   //     if (user.isLoggenIn) {
//   //       user.me();
//   //     }
//   //   });
//   //   return;
//   // }

//   if (isLoading) {
//     Navigator.of(globalKey.currentContext).pop();
//     isLoading = false;
//     String message = "";
//     message = (dioError.response.data['message'] == null ||
//             dioError.response.data['message'] == "")
//         ? dioError.response.data['error']
//         : dioError.response.data['message'];
//     Navigator.of(globalKey.currentContext)
//         .pushReplacement(MaterialPageRoute(builder: (_) {
//       return ErrorPage(
//         message: message,
//       );
//     }));
//   }
// }

// Route _createLoginRoute() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       var begin = Offset(0.0, 1.0);
//       var end = Offset.zero;
//       var curve = Curves.ease;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }
