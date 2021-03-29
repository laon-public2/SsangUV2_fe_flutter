// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:share_product_v2/providers/contractProvider.dart';
// import 'package:share_product_v2/utils/ConvertNumberFormat.dart';
// import 'package:share_product_v2/widgets/customText.dart';
//
// class Shared extends StatelessWidget {
//   const Shared({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final titleFontStyle = TextStyle(
//         fontSize: 12.sp,
//         fontWeight: FontWeight.w400,
//         color: Color(0xff999999),
//         height: 1.4);
//
//     final contentFontStyle = TextStyle(
//         fontSize: 12.sp,
//         fontWeight: FontWeight.w400,
//         color: Color(0xff555555),
//         height: 1.4);
//
//     Provider.of<ContractProvider>(context, listen: false).contractReceive();
//     return Consumer<ContractProvider>(
//       builder: (_, contracts, __) {
//         return Container(
//           child: ListView.separated(
//               shrinkWrap: false,
//               itemCount: contracts.contractsReceive.length,
//               separatorBuilder: (context, idx) => Divider(
//                     color: Color(0xffdddddd),
//                   ),
//               itemBuilder: (context, idx) {
//                 return ExpansionTile(
//                   title: Text(
//                     contracts.contractsReceive[idx].product.title,
//                     style: TextStyle(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xff333333)),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   subtitle: CustomText(
//                     text: contracts.contractsReceive[idx].borrowedDate
//                             .toString() +
//                         " ~ " +
//                         contracts.contractsReceive[idx].returnDate.toString(),
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w500,
//                     textColor: Color(0xff999999),
//                   ),
//                   trailing: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 2.0),
//                         child: CustomText(
//                           text: contracts
//                                   .contractsReceive[idx].product.member.name
//                                   .toString() +
//                               "님",
//                           fontSize: 12.sp,
//                           textColor: Color(0xff999999),
//                         ),
//                       ),
//                       CustomText(
//                         text: "4.5 점",
//                         fontSize: 14.sp,
//                         textColor: Theme.of(context).primaryColor,
//                       ),
//                     ],
//                   ),
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 15, vertical: 12),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                   child: Text(
//                                 "대여 기간",
//                                 style: titleFontStyle,
//                               )),
//                               Expanded(
//                                 flex: 3,
//                                 child: Text(
//                                   contracts.contractsReceive[idx].borrowedDate
//                                           .toString() +
//                                       " ~ " +
//                                       contracts.contractsReceive[idx].returnDate
//                                           .toString(),
//                                   style: contentFontStyle,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                   child: Text(
//                                 "대여 비용",
//                                 style: titleFontStyle,
//                               )),
//                               Expanded(
//                                 flex: 3,
//                                 child: Text(
//                                   numberWithComma(contracts
//                                           .contractsReceive[idx]
//                                           .product
//                                           .price) +
//                                       "원",
//                                   style: contentFontStyle,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                   child: Text(
//                                 "대여자 연락처",
//                                 style: titleFontStyle,
//                               )),
//                               Expanded(
//                                 flex: 3,
//                                 child: Text(
//                                   // TMPDATA[idx]['detail']['tel'].toString(),
//                                   "010-0000-0000",
//                                   style: contentFontStyle,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                   child: Text(
//                                 "대여자 이메일",
//                                 style: titleFontStyle,
//                               )),
//                               Expanded(
//                                 flex: 3,
//                                 child: Text(
//                                   contracts.contractsReceive[idx].product.member
//                                       .username
//                                       .toString(),
//                                   style: contentFontStyle,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 5),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 RaisedButton(
//                                   color: Colors.white,
//                                   elevation: 0.0,
//                                   shape: RoundedRectangleBorder(
//                                       side: BorderSide(
//                                           color: Color(0xffdddddd), width: 1.0),
//                                       borderRadius: BorderRadius.circular(3.0)),
//                                   onPressed: () {
//                                     Navigator.of(context).pushNamed(
//                                         "/contract/complete/form",
//                                         arguments: {
//                                           "uuid":
//                                               contracts.contractsReceive[idx].id
//                                         });
//                                   },
//                                   child: Text(
//                                     "계약서",
//                                     style: TextStyle(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                                 RaisedButton(
//                                   color: Colors.white,
//                                   elevation: 0.0,
//                                   shape: RoundedRectangleBorder(
//                                       side: BorderSide(
//                                           color: Color(0xffdddddd), width: 1.0),
//                                       borderRadius: BorderRadius.circular(3.0)),
//                                   onPressed: () {
//                                     Navigator.of(context).pushNamed(
//                                       "/chatting",
//                                       arguments: {
//                                         "data":
//                                             contracts.contractsReceive[idx].id,
//                                         'owner': contracts.contractsReceive[idx]
//                                             .product.title,
//                                         'contract':
//                                             contracts.contractsReceive[idx]
//                                       },
//                                     );
//                                   },
//                                   child: Text(
//                                     "채팅내용",
//                                     style: TextStyle(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                                 // RaisedButton(
//                                 //   color: Colors.white,
//                                 //   elevation: 0.0,
//                                 //   shape: RoundedRectangleBorder(
//                                 //       side: BorderSide(
//                                 //           color: Color(0xffdddddd), width: 1.0),
//                                 //       borderRadius: BorderRadius.circular(3.0)),
//                                 //   onPressed: () {},
//                                 //   child: Text(
//                                 //     "평가",
//                                 //     style: TextStyle(
//                                 //       fontSize: 14.sp,
//                                 //       fontWeight: FontWeight.w500,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//         );
//       },
//     );
//   }
// }
