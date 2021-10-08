// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:share_product_v2/model/product.dart';
// import 'package:share_product_v2/pages/mypage/loginpage.dart';
// import 'package:share_product_v2/pages/product/ImageView.dart';
// import 'package:share_product_v2/pages/product/detailMapPage.dart';
// import 'package:share_product_v2/pages/product/modifyProduct.dart';
// import 'package:share_product_v2/providers/contractProvider.dart';
// import 'package:share_product_v2/providers/productController.dart';
// import 'package:share_product_v2/providers/userController.dart';
// import 'package:share_product_v2/utils/ConvertNumberFormat.dart';
// import 'package:share_product_v2/widgets/BackBtn.dart';
// import 'package:share_product_v2/widgets/Map.dart';
// import 'package:share_product_v2/widgets/categoryText.dart';
// import 'package:share_product_v2/widgets/contactDialog.dart';
// import 'package:share_product_v2/widgets/customDoneBtn.dart';
// import 'package:share_product_v2/widgets/customText.dart';
// import 'package:share_product_v2/widgets/customdialog.dart';
// import 'package:share_product_v2/widgets/loading.dart';
// import 'package:share_product_v2/widgets/simpleMap.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class DetailProduct extends StatefulWidget {
//   final String id;
//
//   DetailProduct({this.id});
//
//   @override
//   _DetailProductState createState() => _DetailProductState();
// }
//
// class _DetailProductState extends State<DetailProduct> {
//   Product productData;
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       Provider.of<ProductProvider>(context, listen: false)
//           .getProduct(int.parse(widget.id), context);
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // final Map<String, String> args = ModalRoute.of(context).settings.arguments;
//
//     return Scaffold(
//       backgroundColor: Color(0xffffffff),
//       // body: SafeArea(child: body(context)),
//       body: SafeArea(
//         child: Consumer<ProductProvider>(builder: (_, product, __) {
//           this.productData = product.product;
//
//           return body(context);
//         }),
//       ),
//     );
//   }
//
//   Widget body(context) {
//     return Container(
//       color: Color(0xffFAFAFA),
//       child: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 detailImage(),
//                 productData != null ? product() : Text(""),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   child: productData != null ? description() : Text(""),
//                 ),
//                 productData != null ? location(context) : Text(""),
//                 Padding(
//                     padding: const EdgeInsets.only(
//                         left: 10, right: 10, bottom: 10, top: 26),
//                     child: Consumer<UserProvider>(builder: (_, user, __) {
//                       return (productData != null && user.loginMember != null)
//                           ? productData.member.username !=
//                                   user.loginMember.member.username
//                               ? CustomDoneBtn(
//                                   text: "문의하기",
//                                   func: () {
//                                     showDialog(
//                                         context: context,
//                                         builder: (BuildContext context) {
//                                           return ContactDialog(
//                                               productData.member.name,
//                                               productData.member.username);
//                                         });
//
//                                     /**
//                            * NOTICE : 계약 기능 및 채팅 기능이 삭제됨
//                            */
//
//                                     // Provider.of<ContractProvider>(context,
//                                     //     listen: false)
//                                     //     .contract(productData.id)
//                                     //     .then((value) {
//                                     //   Navigator.of(context).pushNamed("/chatting",
//                                     //       arguments: {
//                                     //         "data": value,
//                                     //         'owner': productData.member.name
//                                     //       });
//                                     // });
//                                   },
//                                 )
//                               // TODO: 밑에 Widget MyProductButton 넣고 이후 수정, 삭제 필요함
//                               : SizedBox(
//                                   child: myProductButton(),
//                                 )
//                           : SizedBox();
//                     })),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 12,
//             left: 16,
//             child: BackBtn(),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget detailImage() {
//     return Container(
//         color: Colors.white,
//         width: double.infinity,
//         height: 280,
//         child: productData != null
//             ? productData.productFiles.length != 0
//                 ? CarouselSlider(
//                     options: CarouselOptions(
//                       height: 280,
//                       viewportFraction: 1.1,
//                       enlargeCenterPage: false,
//                       enableInfiniteScroll: false,
//                     ),
//                     items: productData.productFiles.map((i) {
//                       return Builder(
//                         builder: (BuildContext context) {
//                           return Container(
//                               width: 360.h,
//                               margin: EdgeInsets.symmetric(horizontal: 5.0),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   Navigator.of(context)
//                                       .push(MaterialPageRoute(builder: (_) {
//                                     return ImageView(
//                                       allPath: productData.productFiles,
//                                       path: i,
//                                     );
//                                   }));
//                                 },
//                                 child: Hero(
//                                   tag: "image",
//                                   child: Image.network(
//                                     "http://ssangu.oig.kr:8080/resources?path=${i.path}",
//                                     height: 280,
//                                     width: double.infinity,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ));
//                         },
//                       );
//                     }).toList(),
//                   )
//                 : SizedBox(
//                     height: 360.h,
//                     child: Center(
//                       child: Icon(
//                         Icons.work_off_outlined,
//                         size: 80,
//                       ),
//                     ),
//                   )
//             : Text(""));
//   }
//
//   Widget dialogChild(String title) {
//     return Column(
//       children: [
//         Text(
//           "$title님에게",
//           style: TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w600,
//               color: Color(0xff333333)),
//         ),
//         SizedBox(
//           height: 12.h,
//         ),
//         Text(
//           "연결하실 방법을 골라주세요.",
//           style: TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w600,
//               color: Color(0xff333333)),
//         ),
//         SizedBox(
//           height: 20.h,
//         ),
//       ],
//     );
//   }
//
//   Widget deleteDialogchild() {
//     return Column(
//       children: [
//         Text(
//           "정말 해당 게시물을",
//           style: TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w600,
//               color: Color(0xff333333)),
//         ),
//         SizedBox(
//           height: 12.h,
//         ),
//         Text(
//           "삭제하시겠습니까?",
//           style: TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w600,
//               color: Color(0xff333333)),
//         ),
//         SizedBox(
//           height: 20.h,
//         ),
//       ],
//     );
//   }
//
//   Widget myProductButton() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.only(bottom: 16),
//       child: Row(
//         children: [
//           Expanded(
//             child: SizedBox(
//               height: 48.h,
//               child: RaisedButton(
//                 onPressed: () {
//                   showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return CustomDialog(
//                             deleteDialogchild(),
//                             "삭제하기",
//                             () => Provider.of<ProductProvider>(context,
//                                     listen: false)
//                                 .deleteProduct(context, productData.id));
//                       });
//                 },
//                 child: CustomText(
//                   text: "삭제하기",
//                   fontSize: 16.sp,
//                 ),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5)),
//                 textColor: Color(0xff999999),
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 10,
//           ),
//           Expanded(
//             child: SizedBox(
//               height: 48.h,
//               child: RaisedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) {
//                         return ModifyProduct(product: this.productData);
//                       },
//                     ),
//                   );
//                 },
//                 child: CustomText(
//                   text: "수정하기",
//                   fontSize: 16.sp,
//                 ),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5)),
//                 textColor: Colors.white,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget product() {
//     return Column(
//       children: [
//         Container(
//           height: 1.0,
//           color: Color(0xffDDDDDD),
//         ),
//         Container(
//           color: Colors.white,
//           constraints: BoxConstraints(
//             minHeight: 118,
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 13),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 4.0),
//                 child: Row(
//                   children: [
//                     CategoryText(productData.category.name),
//                     Spacer(),
//                     CustomText(
//                       text: "0.2km",
//                       fontSize: 14.sp,
//                       textColor: Color(0xff999999),
//                     )
//                   ],
//                 ),
//               ),
//               Text(
//                 productData.title,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xff333333),
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 15),
//                 child: CustomText(
//                   text: productData.member.name,
//                   fontSize: 14.sp,
//                   textColor: Color(0xff999999),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: CustomText(
//                   text: productData.price == 0
//                       ? "문의"
//                       : "${numberWithComma(productData.price)}원",
//                   textColor: Color(0xff333333),
//                   fontSize: 14.sp,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           height: 1.0,
//           color: Color(0xffDDDDDD),
//         ),
//       ],
//     );
//   }
//
//   Widget description() {
//     return Column(
//       children: [
//         Container(
//           height: 1.0,
//           color: Color(0xffDDDDDD),
//         ),
//         Container(
//           color: Colors.white,
//           padding: const EdgeInsets.all(16),
//           constraints: BoxConstraints(minWidth: double.infinity),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   productData.description,
//                   style:
//                       TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           height: 1.0,
//           color: Color(0xffDDDDDD),
//         ),
//       ],
//     );
//   }
//
//   Widget location(context) {
//     print(productData.member.address.address);
//     print(productData.member.address.point);
//     return Column(
//       children: [
//         Container(
//           height: 1.0,
//           color: Color(0xffDDDDDD),
//         ),
//         Container(
//           color: Colors.white,
//           width: double.infinity,
//           constraints: BoxConstraints(minHeight: 216),
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: Text(
//                   productData.member.address.address != null
//                       ? productData.member.address.address
//                       : "주소 없음",
//                   style: Theme.of(context).textTheme.headline6,
//                 ),
//               ),
//               Stack(
//                 children: [
//                   Container(
//                     height: 200,
//                     child: SimpleGoogleMaps(
//                         latitude: double.parse(
//                             productData.member.address.point.split(", ")[0]),
//                         longitude: double.parse(
//                             productData.member.address.point.split(", ")[1])),
//                   ),
//                   InkWell(
//                       onTap: () {
//                         Navigator.of(context)
//                             .push(MaterialPageRoute(builder: (_) {
//                           return DetailMapPage(
//                               address: productData.member.address.address,
//                               latitude: double.parse(productData
//                                   .member.address.point
//                                   .split(", ")[0]),
//                               longitude: double.parse(productData
//                                   .member.address.point
//                                   .split(", ")[1]));
//                         }));
//                       },
//                       child: Container(
//                         height: 200,
//                         // color: Colors.black.withOpacity(0.2),
//                       ))
//                 ],
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
