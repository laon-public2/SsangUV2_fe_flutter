import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/model/product.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/customText.dart';

import '../../providers/productProvider.dart';
import '../../widgets/CustomDropdown.dart';

class Share extends StatefulWidget {
  const Share({Key key}) : super(key: key);

  @override
  _ShareState createState() => _ShareState();
}

class _ShareState extends State<Share> {

  final List<String> itemKind = [
    "빌린내역",
    "빌려준내역",
  ];
  ScrollController sharedScroll = ScrollController();
  String _currentItem = "";
  int page = 0;

  sharedScrollListener() async {
    final pvm =  Provider.of<ProductProvider>(context, listen: false);
    if(sharedScroll.position.pixels == sharedScroll.position.maxScrollExtent){
      print("스크롤이 가장 아래에 있습니다.");
      if(_currentItem == "빌린내역") {
        if(pvm.rentListCounter.totalCount != pvm.rentListItem.length){
          this.page++;
          await pvm.rentHistory(
              Provider.of<UserProvider>(context, listen: false).userIdx,
              page,
              Provider.of<UserProvider>(context, listen: false).accessToken);
        }
      }else{
        if(pvm.rentListCounter.totalCount != pvm.rentListItem.length){
          this.page++;
          await pvm.rentHistoryWant(
              Provider.of<UserProvider>(context, listen: false).userIdx,
              page,
              Provider.of<UserProvider>(context, listen: false).accessToken);
        }
      }
    }
  }

  Future<bool> loadData() async {
    await Provider.of<ProductProvider>(context, listen: false).rentHistory(
        Provider.of<UserProvider>(context, listen: false).userIdx,
        page,
        Provider.of<UserProvider>(context, listen: false).accessToken);
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
            child: Consumer<ProductProvider>(
              builder: (_, product, __) {
                return Column(
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
                                  Provider.of<ProductProvider>(context, listen: false)
                                      .rentHistory(
                                    Provider.of<UserProvider>(context, listen: false)
                                        .userIdx,
                                    0,
                                    Provider.of<UserProvider>(context, listen: false)
                                        .accessToken,
                                  );
                                }else{
                                  Provider.of<ProductProvider>(context, listen: false)
                                      .rentHistoryWant(
                                    Provider.of<UserProvider>(context, listen: false)
                                        .userIdx,
                                    0,
                                    Provider.of<UserProvider>(context, listen: false)
                                        .accessToken,
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
                      itemCount: this._currentItem == "빌린내역" ? product.rentListItem.length
                          : product.rentListItemWant.length,
                      separatorBuilder: (context, idx) => Divider(
                        color: Color(0xffdddddd),
                      ),
                      itemBuilder: (context, idx){
                        return ListTile(
                          onTap: () {},
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 48.w,
                              height: 48.h,
                              child: Image.network(
                                "http://192.168.100.232:5066/assets/images/product/${product.rentListItem[idx].productFiles[0].path}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            product.rentListItem[idx].productTitle,
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
                                text: "${product.rentListItem[idx].receiverName}님",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                textColor: Color(0xff999999),
                              ),
                              Row(
                                children: <Widget>[
                                  CustomText(
                                    text: _dateFormat(
                                        product.rentListItem[idx].startDate),
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
                                        product.rentListItem[idx].endDate),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    textColor: Color(0xff999999),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
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
