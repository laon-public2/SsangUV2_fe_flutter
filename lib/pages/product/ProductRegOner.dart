// import 'package:flutter/material.dart';
// import 'package:share_product_v2/main.dart';
// import 'package:share_product_v2/widgets/CustomDatePicker.dart';
// import 'dart:math';
// import 'package:share_product_v2/widgets/CustomOnlyInputFieldContainer.dart';
// import 'package:share_product_v2/consts/textStyle.dart';
//
// class ProductRegSecond extends StatefulWidget {
//   @override
//   _ProductRegSecondState createState() => _ProductRegSecondState();
// }
//
// class _ProductRegSecondState extends State<ProductRegSecond> {
//   String adressType;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         leading: Transform.rotate(
//           angle: 180 * pi / 180,
//           child: IconButton(
//             icon: Icon(
//               Icons.arrow_forward,
//               color: Colors.black,
//               size: 30.0,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//       ),
//       body: _body(),
//     );
//   }
//
//   _body() {
//     return Container(
//       child: Stack(
//         children: [
//           Positioned.fill(
//             child: SingleChildScrollView(
//               child: Container(
//                 padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
//                 color: Colors.white,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       '상품등록하기',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Container(
//                       width: 100,
//                       height: 100,
//                       color: Colors.grey,
//                     ),
//                     SizedBox(height: 20),
//                     CustomTextFieldContainer(title: '상품명 입력'),
//                     CustomDate(),
//                     Container(
//                       width: double.infinity,
//                       height: 52,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Expanded(
//                             child: RadioListTile(
//                               title: Text(
//                                 "우리동네 포함 모든지역",
//                                 style: TextStyle(
//                                   color: Color(0xff444444),
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: RadioListTile(
//                               title: Text(
//                                 "우리동네만",
//                                 style: TextStyle(
//                                   color: Color(0xff444444),
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       width: double.infinity,
//                       height: 80,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Expanded(
//                             flex: 4,
//                             child: TextField(
//                               decoration: InputDecoration(
//                                 labelText: "최저가격",
//                                 border: OutlineInputBorder(),
//                               ),
//                               keyboardType: TextInputType.number,
//                             ),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "~",
//                                   style: normal_14_primary,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             flex: 4,
//                             child: TextField(
//                               decoration: InputDecoration(
//                                 labelText: "최고가격",
//                                 border: OutlineInputBorder(),
//                               ),
//                               keyboardType: TextInputType.number,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     CustomTextFieldContainer(title: '주소 입력'),
//                     CustomTextFieldContainer(title: '기타 지역 설정'),
//                     Container(
//                       width: double.infinity,
//                       height: 200,
//                       color: Colors.white,
//                       child: Column(
//                         children: [
//                           Container(
//                             width: double.infinity,
//                             height: 52,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 RichText(
//                                   text: TextSpan(
//                                     children: [
//                                       WidgetSpan(
//                                         child: Icon(
//                                           Icons.priority_high,
//                                           size: 14,
//                                           color: Color(0xff444444),
//                                         ),
//                                       ),
//                                       TextSpan(
//                                           text: " 꼭 읽어주세요!",
//                                           style: TextStyle(
//                                               color: Color(0xff444444))),
//                                     ],
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Text(
//                                   "자세히",
//                                   style: TextStyle(
//                                     color: Color(0xff444444),
//                                     fontWeight: FontWeight.normal,
//                                     decoration: TextDecoration.underline,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Text(
//                             "상품등록 시 번개페이가 자동 적용됩니다. 거래완료 후 등록된 계좌로 입금되며 정산 확인은 '마이메뉴>구매/판매내역'에서 가능합니다.",
//                             style: TextStyle(
//                               color: Color(0xff444444),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 20,
//             child: Container(
//               padding: const EdgeInsets.only(
//                 left: 16,
//                 right: 16,
//               ),
//               child: Container(
//                 width: double.infinity,
//                 height: 52,
//                 decoration: BoxDecoration(
//                   color: Color(0xffff0066),
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       offset: Offset(4, 4),
//                       blurRadius: 4,
//                       spreadRadius: 1,
//                       color: Colors.black.withOpacity(0.08),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Text(
//                     '등록완료 및 알림 전송',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
