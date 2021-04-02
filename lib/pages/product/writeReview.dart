import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';

class WriteReview extends StatefulWidget {
  final int productIdx;

  WriteReview(this.productIdx);

  @override
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  TextEditingController descriptionContorller = TextEditingController();
  num ratingCount;
  String _isDialogText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appbar(),
      body: _body(),
    );
  }

  _appbar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 30.0,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        "리뷰작성",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      elevation: 1.0,
    );
  }

  _body() {
    return Consumer<UserProvider>(
      builder: (__, _myInfo, _) {
        return Consumer<ProductProvider>(builder: (__, _myProduct, _) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 16),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 50.h,
                            child: Center(
                              child: RatingBar.builder(
                                itemSize: 30,
                                minRating: 0,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    ratingCount = rating;
                                  });
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                '매장을 평가해주세요.',
                                style: TextStyle(
                                  color: Color(0xff999999),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Color(0xffdddddd),
                          ),
                          description(descriptionContorller),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  child: InkWell(
                    onTap: () {
                      if (descriptionContorller.text == "") {
                        setState(() {
                          _isDialogText = "리뷰를 입력해주세요.";
                        });
                        _showDialog();
                      } else {
                        _myProduct.sendReview(
                            _myInfo.userIdx,
                            this.widget.productIdx,
                            this.descriptionContorller.text,
                            this.ratingCount.toInt(),
                            _myInfo.accessToken);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50.h,
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffff0066),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '완료',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget description(TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      // hack textfield height
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        style: TextStyle(fontSize: 14, color: Color(0xff333333)),
        maxLength: 50,
        maxLines: 15,
        controller: controller,
        decoration: InputDecoration(
          hintText: "리뷰를 50자 내외로 작성해주세요.",
          hintStyle: TextStyle(fontSize: 14, color: Color(0xffaaaaaa)),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApply(Center(child: Text(_isDialogText)), '확인');
        });
  }
}
