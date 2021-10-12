// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:share_product_v2/model/contract.dart';
// import 'package:share_product_v2/model/paging.dart';
// import 'package:share_product_v2/providers/contractController.dart';
// import 'package:share_product_v2/providers/userController.dart';
// import 'package:share_product_v2/utils/APIUtil.dart';
// import 'package:share_product_v2/widgets/chatItem.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:share_product_v2/widgets/customAppBar%20copy.dart';
// import 'package:share_product_v2/widgets/customText.dart';
// import 'package:stomp_dart_client/stomp.dart';
// import 'package:stomp_dart_client/stomp_config.dart';
// import 'package:stomp_dart_client/stomp_frame.dart';
// import 'dart:convert';
//
// class StompSendDTO {
//   String type = "";
//   String roomId = "";
//   String message = "";
//   String sender = "";
//   String createdDate = "";
//
//   StompSendDTO(
//       {this.type, this.roomId, this.message, this.sender, this.createdDate});
//
//   Map<String, dynamic> toJson() => {
//         'type': type,
//         'roomId': roomId,
//         'message': message,
//         'sender': sender,
//       };
//
//   StompSendDTO.fromJson(Map<String, dynamic> json)
//       : type = json['type'],
//         roomId = json['roomId'],
//         sender = json['sender'],
//         message = json['message'],
//         createdDate = json['createdDate'];
// }
//
// class Chatting extends StatefulWidget {
//   @override
//   _ChattingState createState() => _ChattingState();
// }
//
// class _ChattingState extends State<Chatting> {
//   String uuid = "";
//   String owner = "";
//   StompClient client;
//   List<StompSendDTO> datas = List<StompSendDTO>();
//   UserProvider userProvider;
//   Map<String, String> headers;
//   ScrollController chatController = new ScrollController();
//   TextEditingController textEditingController = new TextEditingController();
//   Paging paging;
//
//   @override
//   void initState() {
//     super.initState();
//     userProvider = Provider.of<UserProvider>(context, listen: false);
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       String token = ApiUtils.instance.dio.options.headers['Authorization'];
//       headers = {"Authorization": token};
//       setClient();
//       Provider.of<ContractProvider>(context, listen: false).contractUUID(uuid);
//     });
//   }
//
//   send(String text) {
//     StompSendDTO data =
//         StompSendDTO(type: "TALK", roomId: uuid, message: text, sender: "");
//     client.send(
//         destination: "/pub/chat/message",
//         body: json.encode(data.toJson()),
//         headers: headers);
//
//     textEditingController.text = "";
//   }
//
//   setClient() {
//     client = StompClient(
//         config: StompConfig(
//             url: "ws://192.168.100.204:8090/ws-stomp",
//             onConnect: (StompClient _client, StompFrame connectFrame) {
//               print("connect: ${_client.connected}");
//               Provider.of<ContractProvider>(context, listen: false)
//                   .getChatHistory(uuid, 0);
//               String roomID = "/sub/chat/rooms/$uuid";
//               _client.subscribe(
//                   destination: roomID,
//                   headers: headers,
//                   callback: (frame) {
//                     print("framebody: ${frame.body}");
//                     StompSendDTO dto =
//                         StompSendDTO.fromJson(json.decode(frame.body));
//                     if (dto.sender ==
//                         userProvider.loginMember.member.username) {
//                       chatController
//                           .jumpTo(chatController.position.minScrollExtent);
//                     }
//
//                     // if (dto.type == "CONTRACT") {
//                     //   Provider.of<ContractProvider>(context, listen: false)
//                     //       .contractUUID(uuid);
//                     // }
//
//                     Provider.of<ContractProvider>(context, listen: false)
//                         .addChat(dto);
//                   });
//             },
//             onStompError: (error) => print("stompError : ${error.body}"),
//             onWebSocketError: (error) => print("error : ${error.toString()}"),
//             stompConnectHeaders: headers,
//             webSocketConnectHeaders: headers));
//
//     client.activate();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
//
//     uuid = args['data'];
//     owner = args['owner'];
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       // chatController.jumpTo(chatController.position.maxScrollExtent);
//     });
//
//     return Scaffold(
//       appBar: CustomAppBar.appBarWithPrev("${owner}", 1.0, context),
//       body: body(context),
//     );
//   }
//
//   Widget body(context) {
//     return Consumer<ContractProvider>(
//       builder: (_, contracts, __) {
//         // this.datas = contracts.chatHistories;
//         if (contracts.paging == null) return SizedBox();
//         this.paging = contracts.paging;
//         WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//           // chatController.jumpTo(chatController.position.maxScrollExtent);
//         });
//         return Container(
//           width: double.infinity,
//           height: double.infinity,
//           child: Column(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Stack(
//                     children: [
//                       Positioned.fill(
//                         bottom: 60,
//                         child: ListView.builder(
//                           controller: chatController,
//                           reverse: true,
//                           itemBuilder: (context, idx) {
//                             if (this.paging.currentPage <
//                                     this.paging.totalPage &&
//                                 idx == 0) {
//                               Provider.of<ContractProvider>(context,
//                                       listen: false)
//                                   .getChatHistory(
//                                       uuid, this.paging.currentPage + 1);
//                             }
//                             if (userProvider.loginMember.member.username ==
//                                 contracts.chatHistories[idx].sender) {
//                               return myChat(
//                                   contracts.chatHistories[idx].message,
//                                   contracts.chatHistories[idx].createdDate);
//                             } else {
//                               return uChat(
//                                   contracts.chatHistories[idx].sender,
//                                   contracts.chatHistories[idx].message,
//                                   contracts.chatHistories[idx].createdDate);
//                             }
//                           },
//                           shrinkWrap: true,
//                           itemCount: contracts.chatHistories.length,
//                         ),
//                         // child: ListView(
//                         //   controller: chatController,
//                         //   shrinkWrap: true,
//                         //   children: [
//                         //     desc(),
//                         //     Column(
//                         //       mainAxisAlignment: MainAxisAlignment.start,
//                         //       crossAxisAlignment: CrossAxisAlignment.start,
//                         //       children: datas.map((e) {
//                         //         if (userProvider.loginMember.member.username ==
//                         //             e.sender) {
//                         //           return myChat(e.message, e.createdDate);
//                         //         } else {
//                         //           return uChat(
//                         //               e.sender, e.message, e.createdDate);
//                         //         }
//                         //       }).toList(),
//                         //     ),
//                         //     // SizedBox(
//                         //     //   height: 60,
//                         //     // ),
//                         //   ],
//                         // ),
//                       ),
//                       Positioned(
//                         left: 0,
//                         right: 0,
//                         bottom: 20,
//                         child: Center(
//                           child: checkBtn(context, contracts),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: -1,
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 20),
//                   child: input(context),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget desc() {
//     return Center(
//       child: Container(
//         constraints: BoxConstraints(
//           minHeight: 36,
//         ),
//         width: 248,
//         margin: const EdgeInsets.only(top: 16, bottom: 8),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30.0),
//             color: Color(0xffEEEEEE),
//           ),
//           padding: const EdgeInsets.all(4),
//           child: Center(
//             child: Text(
//               "채팅 내용은 최대 30일까지 보관되며,\n대여기간 종료 후 자동 삭제됩니다.",
//               style: TextStyle(
//                 fontSize: 10,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget myChat(String text, String date) {
//     DateTime parseDate = DateFormat("yyyy-MM-ddThh:mm:ss").parse(date);
//     date = DateFormat("MM/dd hh:mm").format(parseDate);
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 4),
//             child: ChatItem(
//               text: text,
//               color: Color(0xffEEEEEE),
//               alignment: Alignment.centerRight,
//             ),
//           ),
//           Text("$date"),
//         ],
//       ),
//     );
//   }
//
//   Widget uChat(String user, String text, String date) {
//     DateTime parseDate = DateFormat("yyyy-MM-ddThh:mm:ss").parse(date);
//     date = DateFormat("MM/dd hh:mm").format(parseDate);
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 8),
//             child: SizedBox(
//               width: 36,
//               height: 36,
//               child: ClipOval(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(36 / 2),
//                     border: Border.all(),
//                   ),
//                   child: Center(
//                     child: Icon(Icons.person_outline),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("${user}님"),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4),
//                 child: ChatItem(
//                     text: text,
//                     color: Color(0xffFFFFFF),
//                     alignment: Alignment.centerLeft),
//               ),
//               Text("$date"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget input(context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       constraints: BoxConstraints(
//         minHeight: 40,
//         maxHeight: 100,
//       ),
//       decoration: BoxDecoration(
//           color: Color(0xfff7f7f7),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Color(0xffdddddd))),
//       child: Row(
//         children: [
//           Flexible(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: TextField(
//                 controller: textEditingController,
//                 maxLines: null,
//                 keyboardType: TextInputType.multiline,
//                 decoration: new InputDecoration.collapsed(hintText: ""),
//               ),
//             ),
//           ),
//           InkWell(
//             onTap: () {
//               if (textEditingController.text != "") {
//                 send(textEditingController.text);
//               }
//             },
//             child: Container(
//               width: 32,
//               height: 32,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Theme.of(context).primaryColor,
//               ),
//               margin: const EdgeInsets.symmetric(horizontal: 4.0),
//               child: Center(
//                   child: Image.asset(
//                 "assets/icon/send.png",
//                 width: 14,
//                 height: 14,
//               )),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget checkBtn(context, ContractProvider provider) {
//     print(provider.contractModel.status);
//     if (provider.contractModel == null) return SizedBox();
//     if (provider.contractModel.product.member.id ==
//         userProvider.loginMember.member.id) {
//       if (provider.contractModel.status == "INIT" ||
//           provider.contractModel.status == "CANCEL") return btn(context);
//     } else {
//       if (provider.contractModel.status == "WAIT_FOR_APPROVAL")
//         return contract(context);
//     }
//     return SizedBox();
//   }
//
//   Widget btn(context) {
//     return InkWell(
//       onTap: () {
//         Navigator.of(context)
//             .pushNamed("/contract", arguments: {'uuid': uuid}).then((value) {
//           if (value) {
//             StompSendDTO data = StompSendDTO(
//                 type: "CONTRACT",
//                 roomId: uuid,
//                 message: "계약서가 도착했습니다.",
//                 sender: "");
//             client.send(
//                 destination: "/pub/chat/message",
//                 body: json.encode(data.toJson()),
//                 headers: headers);
//           }
//         });
//       },
//       child: Container(
//         width: 120,
//         height: 36,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             color: Theme.of(context).primaryColor),
//         child: Center(
//             child: CustomText(
//           text: "계약서 작성",
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w500,
//           textColor: Colors.white,
//         )),
//       ),
//     );
//   }
//
//   Widget contract(context) {
//     return InkWell(
//       onTap: () {
//         Provider.of<ContractProvider>(context, listen: false)
//             .contractaApproval(uuid)
//             .then((value) {
//           if (value) {
//             StompSendDTO data = StompSendDTO(
//                 type: "CONTRACT",
//                 roomId: uuid,
//                 message: "계약이 완료되었습니다.",
//                 sender: "");
//             client.send(
//                 destination: "/pub/chat/message",
//                 body: json.encode(data.toJson()),
//                 headers: headers);
//
//             Navigator.of(context)
//                 .pushNamed("/contract/complete", arguments: {"uuid": uuid});
//           }
//         });
//       },
//       child: Container(
//         width: 120,
//         height: 36,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             color: Theme.of(context).primaryColor),
//         child: Center(
//             child: CustomText(
//           text: "계약하기",
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w500,
//           textColor: Colors.white,
//         )),
//       ),
//     );
//   }
// }
