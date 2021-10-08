//빌려 드려요
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/product/ProductDetail.dart';
import 'package:share_product_v2/pages/product/ProductDetailRent.dart';
import 'package:share_product_v2/providers/productController.dart';
import 'package:share_product_v2/widgets/categoryContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LendItemMainPage extends StatelessWidget {
  final String category;
  final String title;
  final String name;
  final String price;
  final String distance;
  final int idx;
  final String picture;
  final int? receiverIdx;

  LendItemMainPage({required this.idx, required this.category, required this.title, required this.name, required this.price, required this.distance, required this.picture, this.receiverIdx});


  // Future<void> _loadLocator() async {
  //   this.address = ["37.468429845611105", "126.88627882228076"];
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String addStr = pref.get("address");
  //   List<String> address;
  //   address = addStr.split(',');
  //   print("주소 ===== $address");
  //   Provider.of<ProductProvider>(context, listen: false)
  //       .getproductDetail(this.widget.productIdx, address[0], address[1]);
  //   Provider.of<ProductProvider>(context, listen: false)
  //       .getProductReviewFive(this.widget.productIdx, _page);
  // }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      // color: Colors.white,
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
              child: ProductDetailRent(this.idx, this.category),
              type: PageTransitionType.fade,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 111.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'http://115.91.73.66:15066/assets/images/product/${this.picture}',
                  height: 100.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 211.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryContainer(
                        category: this.category,
                      ),
                      Text(
                        '${this.distance}km',
                        style: TextStyle(color: Color(0xff999999)),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 211.w,
                      ),
                      child: Text(
                        this.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xff333333),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(),
                  child: Text(
                    this.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xff999999),
                    ),
                  ),
                ),
                Text(
                  "${this.price} / 일",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Color(0xff333333),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
