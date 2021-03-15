import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/contractProvider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/utils/ConvertNumberFormat.dart';
import 'package:share_product_v2/widgets/customText.dart';

class Share extends StatelessWidget {
  const Share({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int page = 0;
    Future<bool> loadData() async{
      await Provider.of<ProductProvider>(context, listen: false).rentHistory(
          Provider.of<UserProvider>(context, listen: false).userIdx,
          page,
          Provider.of<UserProvider>(context, listen: false).accessToken
      );
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
      builder: (context, snapshot){
        if(snapshot.hasData == false){
          return Container(
            height: 300.h,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffff0066)),
              ),
            ),
          );
        }else if(snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error ${snapshot.hasError}',
              style: TextStyle(fontSize: 15),
            ),
          );
        }else{
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
                      if(idx == product.rentListItem.length) {
                        if(idx == product.rentListCounter.totalCount){
                          return Container();
                        }else{
                          page++;
                          Provider.of<ProductProvider>(context, listen: false).rentHistory(
                            Provider.of<UserProvider>(context, listen: false).userIdx,
                            page,
                            Provider.of<UserProvider>(context, listen: false).accessToken,
                          );
                        }
                      }
                      return ExpansionTile(
                        title: Text(
                          product.rentListItem[idx].productTitle,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff333333)),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: CustomText(
                          text: 'adfadad' +
                              " ~ " +
                              'adfasdfasdf',
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          textColor: Color(0xff999999),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: CustomText(
                                text: product.rentListItem[idx].senderName
                                    .toString() +
                                    "님",
                                fontSize: 12.sp,
                                textColor: Color(0xff999999),
                              ),
                            ),
                            CustomText(
                              text: "4.5 점",
                              fontSize: 14.sp,
                              textColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                          "대여 기간",
                                          style: titleFontStyle,
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "dfadfa"
                                            .toString() +
                                            " ~ " +
                                            "dfadfasdf"
                                                .toString(),
                                        style: contentFontStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                          "대여 비용",
                                          style: titleFontStyle,
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        numberWithComma(product.rentListItem[idx].productPrice) +
                                            "원",
                                        style: contentFontStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                          "대여자 연락처",
                                          style: titleFontStyle,
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        // TMPDATA[idx]['detail']['tel'].toString(),
                                        "010-0000-0000",
                                        style: contentFontStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                          "대여자 이메일",
                                          style: titleFontStyle,
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        product.rentListItem[idx].receiverName
                                            .toString(),
                                        style: contentFontStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      RaisedButton(
                                        color: Colors.white,
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Color(0xffdddddd), width: 1.0),
                                            borderRadius: BorderRadius.circular(3.0)),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              "/contract/complete/form",
                                              arguments: {
                                                "uuid": product.rentListItem[idx].uuid
                                              });
                                        },
                                        child: Text(
                                          "계약서",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      RaisedButton(
                                        color: Colors.white,
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Color(0xffdddddd), width: 1.0),
                                            borderRadius: BorderRadius.circular(3.0)),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                            "/chatting",
                                            arguments: {
                                              "data": "sds",
                                              'owner': "adfas",
                                              'contract': "adf"
                                            },
                                          );
                                        },
                                        child: Text(
                                          "채팅내용",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      // RaisedButton(
                                      //   color: Colors.white,
                                      //   elevation: 0.0,
                                      //   shape: RoundedRectangleBorder(
                                      //       side: BorderSide(
                                      //           color: Color(0xffdddddd), width: 1.0),
                                      //       borderRadius: BorderRadius.circular(3.0)),
                                      //   onPressed: () {},
                                      //   child: Text(
                                      //     "평가",
                                      //     style: TextStyle(
                                      //       fontSize: 14.sp,
                                      //       fontWeight: FontWeight.w500,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
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
}
