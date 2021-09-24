import 'package:flutter/material.dart';
import 'package:share_product_v2/widgets/customText.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  
  const CustomAppBar({Key? key, required this.appBar, required this.title, this.elevation}) : super(key: key);

  final AppBar appBar;
  final String? title;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      title: CustomText(
        text: title,
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: elevation,
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);

}

class AppBarWithPrev extends StatelessWidget implements PreferredSizeWidget{

  const AppBarWithPrev({Key? key, required this.appBar, required this.title, this.elevation}) : super(key: key);

  final AppBar appBar;
  final String? title;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      title: CustomText(
        text: title,
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        textColor: Colors.black,
      ),
      automaticallyImplyLeading: false,
      leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.black,
          )),
      centerTitle: true,
      elevation: elevation,
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);

}

// class CustomAppBar  {
//   static Widget appBar(String title, double elevation) {
//     return
//   }
//
//   static Widget appBarWithPrev(
//       String title, double elevation, BuildContext context) {
//     return AppBar(
//       brightness: Brightness.light,
//       title: CustomText(
//         text: title,
//         fontSize: 16.sp,
//         fontWeight: FontWeight.normal,
//         textColor: Colors.black,
//       ),
//       automaticallyImplyLeading: false,
//       leading: InkWell(
//           onTap: () {
//             Navigator.of(context).pop();
//           },
//           child: Icon(
//             Icons.arrow_back_ios,
//             size: 24,
//             color: Colors.black,
//           )),
//       centerTitle: true,
//       elevation: elevation,
//       backgroundColor: Colors.white,
//     );
//   }
// }
