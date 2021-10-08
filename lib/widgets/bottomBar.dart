// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:share_product_v2/pages/CustomerMessage.dart';
// import 'package:share_product_v2/pages/ProductReg.dart';
// import 'package:share_product_v2/pages/auth/myPage.dart';
// import 'package:share_product_v2/pages/auth/noLoginMyPage.dart';
// import 'package:share_product_v2/pages/history/history.dart';
// import 'package:share_product_v2/pages/main.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'dart:io' show Platform;

// import 'package:share_product_v2/providers/userController.dart';
// import 'package:share_product_v2/widgets/customdialog.dart';

// class BottomBar extends StatefulWidget {
//   @override
//   _BottomBarState createState() => _BottomBarState();
// }

// class _BottomBarState extends State<BottomBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: defaultTargetPlatform == TargetPlatform.iOS ? 70.h : 70,
//       padding: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black,
//               offset: Offset(4.0, 4.0),
//               blurRadius: 8.0,
//               spreadRadius: 0.0)
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Container(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                   child: SizedBox(
//                     width: 30,
//                     height: 30,
//                     child: IconButton(
//                       padding: new EdgeInsets.all(0.0),
//                       icon: Icon(
//                         Icons.home,
//                         size: 24,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => MainPage(),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 Text(
//                   "홈",
//                   style: TextStyle(
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                   child: SizedBox(
//                     width: 30,
//                     height: 30,
//                     child: IconButton(
//                       padding: new EdgeInsets.all(0.0),
//                       icon: Icon(
//                         Icons.article_outlined,
//                         size: 24,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         if (Provider.of<UserProvider>(context, listen: false)
//                             .isLoggenIn) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ProductReg(),
//                             ),
//                           );
//                         } else {
//                           _showDialog(context);
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//                 Text(
//                   "글쓰기",
//                   style: TextStyle(
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                   child: SizedBox(
//                     width: 30,
//                     height: 30,
//                     child: IconButton(
//                       padding: new EdgeInsets.all(0.0),
//                       icon: Icon(
//                         Icons.article_outlined,
//                         size: 24,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         if (Provider.of<UserProvider>(context, listen: false)
//                             .isLoggenIn) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => History(),
//                             ),
//                           );
//                         } else {
//                           _showDialog(context);
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//                 Text(
//                   "이용내역",
//                   style: TextStyle(
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                   child: SizedBox(
//                     width: 30,
//                     height: 30,
//                     child: IconButton(
//                       padding: new EdgeInsets.all(0.0),
//                       icon: Icon(
//                         Icons.account_circle,
//                         size: 24,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => MyPage(),
//                           ),
//                         );
//                         // Navigator.pushNamed(context, '/chatting');
//                       },
//                     ),
//                   ),
//                 ),
//                 Text(
//                   "마이페이지",
//                   style: TextStyle(
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDialog(context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return CustomDialog(_notLoginText(), '확인', () {
//             Navigator.pushNamed(context, '/myPageInit');
//           });
//         });
//   }

//   _notLoginText() {
//     return Column(
//       children: [
//         Text(
//           '로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 14,
//           ),
//         ),
//         SizedBox(height: 20.h),
//       ],
//     );
//   }
// }
//사용되지 않습니다.
