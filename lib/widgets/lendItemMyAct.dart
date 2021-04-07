//빌려 드려요
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/product/ProductDetail.dart';
import 'package:share_product_v2/pages/product/ProductDetailMyact.dart';
import 'package:share_product_v2/pages/mypage/myActHistory.dart';
import 'package:share_product_v2/pages/product/ProductDetailRent.dart';
import 'package:share_product_v2/providers/myPageProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/categoryContainer.dart';

class LendItemMyAct extends StatefulWidget {
  final int idx;
  final String category;
  final String title;
  final String name;
  final String price;
  String status;
  final String picFile;
  final String token;
  int arrayNum;

  LendItemMyAct({
    this.token,
    this.idx,
    this.category,
    this.title,
    this.name,
    this.price,
    this.status,
    this.picFile,
    this.arrayNum,
  });

  @override
  _LendItemMyActState createState() => _LendItemMyActState();
}

class _LendItemMyActState extends State<LendItemMyAct> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // color: Colors.white,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailRent(this.widget.idx, this.widget.category)),
        );
      },
      child: Container(
        width: double.infinity,
        height: 111.h,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  'http://192.168.100.232:5066/assets/images/product/${this.widget.picFile}',
                  height: 100.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 211.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryContainer(
                        category: this.widget.category,
                      ),
                      Text(
                        this.widget.status == "POSSIBLE" ? '대여가능' : "대여중",
                        style: TextStyle(
                          color: this.widget.status == "POSSIBLE"
                              ? Color(0xffff0066)
                              : Color(0xff999999),
                        ),
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
                        this.widget.title,
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
                    this.widget.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xff999999),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 211.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${this.widget.price} / 일",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xff333333),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("${this.widget.category}");
                          MyPageProvider pr = Provider.of<MyPageProvider>(context, listen: false);
                          if (this.widget.status == "IMPOSSIBLE"){
                            pr.rentStatus(this.widget.token, this.widget.idx);
                            pr.rentStatusModified(
                                this.widget.arrayNum, this.widget.status, this.widget.category);
                          }
                          if (this.widget.status == "POSSIBLE"){
                            pr.rentStatus(this.widget.token, this.widget.idx);
                            pr.rentStatusModified(
                                this.widget.arrayNum, this.widget.status, this.widget.category);
                          }

                        },
                        child: Container(
                          width: 110.w,
                          height: 25.h,
                          decoration: BoxDecoration(
                            color: Color(0xffEC327C),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              this.widget.status == "POSSIBLE"
                                  ? '대여중으로 변경'
                                  : "대여가능으로 변경",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
