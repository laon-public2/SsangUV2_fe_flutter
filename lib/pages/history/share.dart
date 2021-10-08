import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/model/product.dart';
import 'package:share_product_v2/providers/productController.dart';
import 'package:share_product_v2/providers/userController.dart';
import 'package:share_product_v2/widgets/customText.dart';

import '../../providers/productController.dart';
import '../../widgets/CustomDropdown.dart';

class Share extends StatefulWidget {
  const Share({Key? key}) : super(key: key);

  @override
  _ShareState createState() => _ShareState();
}

class _ShareState extends State<Share> {

  ProductController productController = Get.find<ProductController>();
  UserController userController = Get.find<UserController>();

  final List<String> itemKind = [
    "대여요청",
    "대여제공",
    "도움요청",
    "도움제공",
  ];
  ScrollController sharedScroll = ScrollController();
  String _currentItem = "";
  int page = 0;

  sharedScrollListener() async {
    final pvm =  productController;
    if(sharedScroll.position.pixels == sharedScroll.position.maxScrollExtent){
      print("스크롤이 가장 아래에 있습니다.");
      if(_currentItem == "대여요청") {
        if(pvm.rentListCounter.totalCount != pvm.rentListItem.length){
          this.page++;
          await pvm.rentHistory(
              userController.userIdx.value,
              page,
              userController.accessToken.value);
        }
      }else{
        if(pvm.rentListCounter.totalCount != pvm.rentListItem.length){
          this.page++;
          await pvm.rentHistoryRent(
              userController.userIdx.value,
              page,
              userController.accessToken.value);
        }
      }
    }
  }

  Future<bool> loadData() async {
    await productController.rentHistory(
        userController.userIdx.value,
        page,
        userController.accessToken.value);
    return false;
  }

  @override
  void initState() {
    _currentItem = itemKind.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final titleFontStyle = TextStyle(
    //     fontSize: 12.sp,
    //     fontWeight: FontWeight.w400,
    //     color: Color(0xff999999),
    //     height: 1.4);
    //
    // final contentFontStyle = TextStyle(
    //     fontSize: 12.sp,
    //     fontWeight: FontWeight.w400,
    //     color: Color(0xff555555),
    //     height: 1.4);
    return FutureBuilder(
      future: loadData(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return Container(
            height: 300.h,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffff0066)),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error ${snapshot.hasError}',
              style: TextStyle(fontSize: 15),
            ),
          );
        } else {
          return Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 60.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0,2),
                              color: Color.fromRGBO(0, 0, 0, 0.15),
                              blurRadius: 8.0,
                            ),
                          ]
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: CustomDropdown(
                              items: itemKind,
                              value: _currentItem,
                              onChange: (value) {
                                setState(() {
                                  _currentItem = value;
                                });
                                if(this._currentItem == "빌린내역"){
                                  productController
                                      .rentHistory(
                                    userController.userIdx.value,
                                    0,
                                    userController.accessToken.value,
                                  );
                                }else{
                                  productController
                                      .rentHistoryRent(
                                    userController.userIdx.value,
                                    0,
                                    userController.accessToken.value,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: this._currentItem == "대여요청" ? productController.rentListItem.length
                          : productController.rentListItemRent.length,
                      separatorBuilder: (context, idx) => Divider(
                        color: Color(0xffdddddd),
                      ),
                      itemBuilder: (context, idx){
                        if(_currentItem == "대여요청") {
                          return ListTile(
                            onTap: () {},
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 48.w,
                                height: 48.h,
                                child: Image.network(
                                  "http://115.91.73.66:15066/assets/images/product/${productController.rentListItem[idx].productFiles[0].path}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              productController.rentListItem[idx].productTitle,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff333333),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: "${productController.rentListItem[idx].receiverName}님",
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  textColor: Color(0xff999999),
                                ),
                                Row(
                                  children: <Widget>[
                                    CustomText(
                                      text: _dateFormat(
                                          productController.rentListItem[idx].startDate),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      textColor: Color(0xff999999),
                                    ),
                                    Text(
                                      ' ~ ',
                                      style: TextStyle(
                                          color: Color(0xff999999),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp),
                                    ),
                                    CustomText(
                                      text: _dateFormat(
                                          productController.rentListItem[idx].endDate),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      textColor: Color(0xff999999),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }else {
                          return ListTile(
                            onTap: () {},
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 48.w,
                                height: 48.h,
                                child: Image.network(
                                  "http://115.91.73.66:15066/assets/images/product/${productController.rentListItemRent[idx].productFiles[0].path}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              productController.rentListItemRent[idx].productTitle,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff333333),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: "${productController.rentListItemRent[idx].receiverName}님",
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  textColor: Color(0xff999999),
                                ),
                                Row(
                                  children: <Widget>[
                                    CustomText(
                                      text: _dateFormat(
                                          productController.rentListItemRent[idx].startDate),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      textColor: Color(0xff999999),
                                    ),
                                    Text(
                                      ' ~ ',
                                      style: TextStyle(
                                          color: Color(0xff999999),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp),
                                    ),
                                    CustomText(
                                      text: _dateFormat(
                                          productController.rentListItemRent[idx].endDate),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      textColor: Color(0xff999999),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                
            ),
          );
        }
      },
    );
  }

  _dateFormat(String date) {
    String formatDate(DateTime date) =>
        new DateFormat("yyyy/MM/dd").format(date);
    return formatDate(DateTime.parse(date));
  }
}
