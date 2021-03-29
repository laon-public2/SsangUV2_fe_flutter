import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/contractProvider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/utils/ConvertNumberFormat.dart';
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
  String _currentItem = "";

  @override
  void initState() {
    _currentItem = itemKind.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int page = 0;
    Future<bool> loadData() async {
      await Provider.of<ProductProvider>(context, listen: false).rentHistory(
          Provider.of<UserProvider>(context, listen: false).userIdx,
          page,
          Provider.of<UserProvider>(context, listen: false).accessToken);
      return false;
    }

    final titleFontStyle = TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: Color(0xff999999),
        height: 1.4);

    final contentFontStyle = TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: Color(0xff555555),
        height: 1.4);

    // Provider.of<ContractProvider>(context, listen: false).contractDo();

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
          return Consumer<ProductProvider>(
            builder: (_, product, __) {
              return Container(
                child: ListView.separated(
                    shrinkWrap: false,
                    itemCount: product.rentListItem.length,
                    separatorBuilder: (context, idx) => Divider(
                          color: Color(0xffdddddd),
                        ),
                    itemBuilder: (context, idx) {
                      if (idx == product.rentListItem.length) {
                        if (idx == product.rentListCounter.totalCount) {
                          return Container();
                        } else {
                          page++;
                          Provider.of<ProductProvider>(context, listen: false)
                              .rentHistory(
                            Provider.of<UserProvider>(context, listen: false)
                                .userIdx,
                            page,
                            Provider.of<UserProvider>(context, listen: false)
                                .accessToken,
                          );
                        }
                      }
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
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          ListTile(
                            onTap: () {},
                            leading: Container(
                              width: 48.w,
                              height: 48.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Color(0xffDDDDDD)),
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Image.network(
                                "http://192.168.100.232:5066/assets/images/product/${product.rentListItem[idx].productFiles[0].path}",
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              // TMPDATA[idx]["title"],
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
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [],
                            ),
                          ),
                        ],
                      );
                    }),
              );
            },
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
