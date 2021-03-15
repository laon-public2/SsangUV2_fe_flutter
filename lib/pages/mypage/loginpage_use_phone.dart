// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:provider/provider.dart';
// import 'package:share_product_v2/providers/mapProvider.dart';
// import 'package:share_product_v2/providers/userProvider.dart';
// import 'package:share_product_v2/widgets/customText.dart';
// import 'package:share_product_v2/widgets/loading.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// enum SmsProcess { INIT, SMS, NICKNAME }

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   SharedPreferences pref;
//   BuildContext context;
//   SmsProcess process = SmsProcess.INIT;

//   // bool isSms = false;
//   // bool isNick = false;

//   TextEditingController _controller = new TextEditingController();
//   TextEditingController _smsController = new TextEditingController();
//   TextEditingController _nicknameController = new TextEditingController();
//   var maskFormatter = new MaskTextInputFormatter(
//       mask: '###-####-####', filter: {"#": RegExp(r'[0-9]')});
//   String verificationId;
//   int forceResendingToken;

//   bool isVerifierError = false;

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       pref = await SharedPreferences.getInstance();
//     });
//     this.context = context;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       body: SafeArea(child: body(context)),
//     );
//     ;
//   }

//   Widget body(context) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       child: Column(
//         children: [
//           Container(
//             alignment: Alignment.centerRight,
//             padding: EdgeInsets.only(top: 10.h, right: 10.h, bottom: 24.h),
//             child: InkWell(
//               child: Icon(Icons.close),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//           // swipeTutorial(context),
//           Expanded(child: form()),
//           Spacer(),
//           btn(),
//           // loginButtons()
//         ],
//       ),
//     );
//   }

//   Widget form() {
//     switch (process) {
//       case SmsProcess.INIT:
//         return phoneInput(context);
//       case SmsProcess.SMS:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             phoneInput(context),
//             Padding(
//               padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
//               child: InkWell(
//                   onTap: () {
//                     sendSms();
//                   },
//                   child: Text("아직 문자가 도착하지 않으셨나요?")),
//             ),
//             smsInput(),
//           ],
//         );
//       case SmsProcess.NICKNAME:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             phoneInput(context),
//             Padding(
//               padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
//               child: Text("아직 문자가 도착하지 않으셨나요?"),
//             ),
//             smsInput(),
//             nicknameInput(),
//           ],
//         );
//     }
//   }

//   Widget btn() {
//     switch (process) {
//       case SmsProcess.INIT:
//         return sendSmsBtn();
//       case SmsProcess.SMS:
//         return smsDone();
//       case SmsProcess.NICKNAME:
//         return signDone();
//     }
//   }

//   Widget phoneInput(context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       // mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: TextField(
//               controller: _controller,
//               inputFormatters: [maskFormatter],
//               onChanged: (value) {},
//               textInputAction: TextInputAction.done,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                   hintText: "휴대폰 번호를 입력해주세요.",
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//                   border: OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.clear),
//                     onPressed: () {
//                       _controller.clear();
//                     },
//                   ))),
//         ),
//       ],
//     );
//   }

//   Widget sendSmsBtn() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
//       child: Container(
//         width: double.infinity,
//         height: 48,
//         child: RaisedButton(
//           onPressed: () {
//             if (_controller.text.length < 8) return;
//             print(123);
//             sendSms();
//           },
//           child: CustomText(
//             text: "인증번호 요청",
//             fontSize: 16.sp,
//           ),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//           textColor: Colors.white,
//           color: Theme.of(context).primaryColor,
//         ),
//       ),
//     );
//   }

//   Widget smsInput() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
//       child: Container(
//         width: double.infinity,
//         height: 48,
//         child: TextField(
//             controller: _smsController,
//             textInputAction: TextInputAction.done,
//             // obscureText: true,
//             decoration: InputDecoration(
//               labelText: isVerifierError ? "인증번호가 올바르지 않습니다." : null,
//               labelStyle: TextStyle(color: Colors.red),
//               // errorText: "asdasdasd",
//               hintText: "인증번호",
//               contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//               border: OutlineInputBorder(),
//             )),
//       ),
//     );
//   }

//   Widget smsDone() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
//       child: Container(
//         width: double.infinity,
//         height: 48,
//         child: RaisedButton(
//           onPressed: () {
//             _showLoading();
//             String smsCode = _smsController.text;
//           },
//           child: CustomText(
//             text: "인증하기",
//             fontSize: 16.sp,
//           ),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//           textColor: Colors.white,
//           color: Theme.of(context).primaryColor,
//         ),
//       ),
//     );
//   }

//   Widget nicknameInput() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
//       child: Container(
//         width: double.infinity,
//         height: 48,
//         child: TextField(
//             controller: _nicknameController,
//             textInputAction: TextInputAction.done,
//             decoration: InputDecoration(
//               hintText: "닉네임",
//               contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//               border: OutlineInputBorder(),
//             )),
//       ),
//     );
//   }

//   Widget signDone() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
//       child: Container(
//         width: double.infinity,
//         height: 48,
//         child: RaisedButton(
//           onPressed: () async {
//             _showLoading();
//             await Provider.of<UserProvider>(context, listen: false)
//                 .getAccessToken(
//                     maskFormatter.getUnmaskedText(), _nicknameController.text);

//             // ========================================================================
//             // 주소 계정과 동기화
//             // ========================================================================
//             String position = pref.getString("address") ?? "NONE";

//             double latitude = double.parse(position.split(",")[0]);
//             double longitude = double.parse(position.split(",")[1]);

//             String address =
//                 await Provider.of<MapProvider>(context, listen: false)
//                     .getAddress(latitude, longitude);

//             Provider.of<UserProvider>(context, listen: false)
//                 .setAddress(context, address, "");
//             // ========================================================================
//             Navigator.of(context).pop();
//             Navigator.of(context).pop();
//           },
//           child: CustomText(
//             text: "완료",
//             fontSize: 16.sp,
//           ),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//           textColor: Colors.white,
//           color: Theme.of(context).primaryColor,
//         ),
//       ),
//     );
//   }

//   sendSms() {
//     _showLoading();
//     FirebaseAuth auth = FirebaseAuth.instance;
//     auth.verifyPhoneNumber(
//         phoneNumber: "+82${maskFormatter.getUnmaskedText()}",
//         verificationCompleted: (AuthCredential authCredential) {},
//         verificationFailed: (FirebaseAuthException authException) {
//           print(authException.message);
//           Navigator.of(context).pop();
//         },
//         forceResendingToken: forceResendingToken,
//         timeout: const Duration(seconds: 90),
//         codeSent: (String verificateionId, [int forceResendingToken]) {
//           //show dialog to take input from the user
//           Navigator.of(context).pop();
//           this.verificationId = verificateionId;
//           this.forceResendingToken = forceResendingToken;
//           setState(() {
//             // isSms = true;
//             process = SmsProcess.SMS;
//           });
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           this.verificationId = verificationId;
//           // Navigator.of(context).pop();
//         });
//   }

//   _showLoading() {
//     showDialog(
//         context: context,
//         barrierColor: Colors.black.withOpacity(0.0),
//         builder: (BuildContext context) {
//           return Loading();
//         });
//   }
// }
