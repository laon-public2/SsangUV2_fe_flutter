// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:share_product_v2/model/paging.dart';
// import 'package:share_product_v2/model/product.dart';
// import 'package:share_product_v2/providers/productProvider.dart';
// import 'package:share_product_v2/utils/ConvertNumberFormat.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:share_product_v2/widgets/categoryText.dart';
// import 'package:share_product_v2/widgets/customAppBar%20copy.dart';
// import 'package:share_product_v2/widgets/customText.dart';
//
// class MyProductPage extends StatelessWidget {
//   Paging paging;
//
//   List<Product> products;
//
//   @override
//   Widget build(BuildContext context) {
//     Provider.of<ProductProvider>(context, listen: false).getMyProduct(0);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar.appBarWithPrev("나의 대여상품", 1.0, context),
//       body: body(),
//     );
//   }
//
//   Widget body() {
//     return Consumer<ProductProvider>(
//       builder: (_, product, __) {
//         print(product.paging);
//         print(product.products);
//         this.paging = product.paging;
//         this.products = product.products;
//         return ListView.builder(
//           itemBuilder: (context, idx) {
//             print(idx);
//             Product product = this.products[idx];
//             if ((this.paging.currentPage < this.paging.totalPage) &&
//                 idx + 1 == products.length &&
//                 idx + 1 < this.paging.totalCount) {
//               Provider.of<ProductProvider>(context, listen: false)
//                   .getMyProduct(this.paging.currentPage + 1);
//             }
//             return InkWell(
//               onTap: () {
//                 Navigator.of(context).pushNamed("/product/detail",
//                     arguments: {"id": "${product.id}"});
//               },
//               child: Item(
//                   product.category.name,
//                   product.title,
//                   product.price,
//                   product.productFiles.isEmpty
//                       ? null
//                       : product.productFiles[0].path,
//                   product.status,
//                   product.id),
//             );
//           },
//           itemCount: this.products.length,
//         );
//       },
//     );
//   }
// }
//
// class Item extends StatelessWidget {
//   final String category;
//   final String title;
//   final int price;
//   final String path;
//   final String status;
//   final int id;
//
//   Item(this.category, this.title, this.price, this.path, this.status, this.id);
//
//   @override
//   Widget build(BuildContext context) {
//     String status_korean = this.status == "RENTABLE" ? "대여중으로 변경" : "대여가능으로 변경";
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.h),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               SizedBox(
//                 height: 96.h,
//                 width: double.infinity,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       width: 72.h,
//                       height: 72.h,
//                       child: Image.network(
//                         "http://192.168.100.232:5066/assets/images/$path",
//                         height: 72.h,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 16.h,
//                     ),
//                     Expanded(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CategoryText(category),
//                           SizedBox(
//                             height: 4.h,
//                           ),
//                           Text(
//                             title,
//                             style: TextStyle(
//                                 fontSize: 12.sp, fontWeight: FontWeight.w500),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(
//                             height: 4.h,
//                           ),
//                           Text(
//                             "${numberWithComma(price)}원",
//                             style: TextStyle(
//                                 fontSize: 12.sp, color: Color(0xff999999)),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               this.status == "RENTING"
//                   ? Container(
//                       height: 96.h,
//                       width: double.infinity,
//                       color: Colors.black.withOpacity(0.2),
//                       child: Center(
//                         child: CustomText(text: "대여중입니다."),
//                       ),
//                     )
//                   : SizedBox(),
//             ],
//           ),
//           InkWell(
//             onTap: () {
//               ProductProvider pr =
//                   Provider.of<ProductProvider>(context, listen: false);
//               if (this.status == "RENTING") pr.rentable(this.id);
//               if (this.status == "RENTABLE") pr.renting(this.id);
//             },
//             child: Container(
//               width: double.infinity,
//               height: 30,
//               child: Center(
//                 child: Text(status_korean),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
