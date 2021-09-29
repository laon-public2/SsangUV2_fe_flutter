import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/chat/CustomerMessage.dart';
import 'package:share_product_v2/providers/contractProvider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/PageTransition.dart';
import 'package:share_product_v2/widgets/customText.dart';

class Chatting extends StatelessWidget {
  const Chatting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int page = 0;

    Future<bool> chatListLoad() async {
      await Provider.of<ProductProvider>(context, listen: false).chatList(
        Provider.of<UserProvider>(context, listen: false).userIdx!,
        page,
        Provider.of<UserProvider>(context, listen: false).accessToken!,
      );
      return false;
    }

    return FutureBuilder(
      future: chatListLoad(),
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
              builder: (_, contracts, __) {
                return ListView.separated(
                    shrinkWrap: false,
                    itemCount: contracts.chatListItem.length,
                    separatorBuilder: (context, idx) => Divider(
                          color: Color(0xffdddddd),
                        ),
                    itemBuilder: (context, idx) {
                      if (idx == contracts.chatListItem.length) {
                        if (idx == contracts.chatListCounter.totalCount) {
                          return Container();
                        } else {
                          page++;
                          Provider.of<ProductProvider>(context, listen: false)
                              .chatList(
                            Provider.of<UserProvider>(context, listen: false)
                                .userIdx!,
                            page,
                            Provider.of<UserProvider>(context, listen: false)
                                .accessToken!,
                          );
                        }
                      }
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransitioned(
                                child: CustomerMessage(
                                  contracts.chatListItem[idx].uuid,
                                  contracts.chatListItem[idx].productIdx,
                                  contracts.chatListItem[idx].productTitle,
                                  _category(
                                      contracts.chatListItem[idx].categoryNum),
                                  contracts.chatListItem[idx].receiverName,
                                  contracts.chatListItem[idx].productPrice,
                                  contracts
                                      .chatListItem[idx].productFiles[0].path,
                                  contracts.chatListItem[idx].status,
                                  contracts.chatListItem[idx].receiverIdx,
                                  contracts.chatListItem[idx].senderFcmToken,
                                  contracts.chatListItem[idx].receiverFcmToken,
                                  contracts.chatListItem[idx].senderIdx,
                                ),
                                curves: Curves.fastOutSlowIn,
                                duration: const Duration(milliseconds: 800),
                                durationRev: const Duration(milliseconds: 600),
                            )
                          );
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 48.w,
                            height: 48.h,
                            child: Image.network(
                              "http://115.91.73.66:15066/assets/images/product/${contracts.chatListItem[idx].productFiles[0].path}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          // TMPDATA[idx]["title"],
                          contracts.chatListItem[idx].productTitle,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff333333),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: CustomText(
                          text: contracts.chatListItem[idx].receiverName,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          textColor: Color(0xff999999),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // CustomText(
                            //   text:
                            //   contracts.contracts[idx].createdDate.split("T")[0],
                            //   fontSize: 12.sp,
                            //   textColor: Color(0xff999999),
                            // ),
                          ],
                        ),
                      );
                    });
              },
            ),
          );
        }
      },
    );
  }

  _category(int categoryNum) {
    if (categoryNum == 2) {
      String value = '생활용품';
      return value;
    } else if (categoryNum == 3) {
      String value = '스포츠/레저';
      return value;
    } else if (categoryNum == 4) {
      String value = '육아';
      return value;
    } else if (categoryNum == 5) {
      String value = '반려동물';
      return value;
    } else if (categoryNum == 6) {
      String value = '가전제품';
      return value;
    } else if (categoryNum == 7) {
      String value = '의류/잡화';
      return value;
    } else if (categoryNum == 8) {
      String value = '가구/인테리어';
      return value;
    } else if (categoryNum == 9) {
      String value = '자동차용품';
      return value;
    } else if (categoryNum == 10) {
      String value = '기타';
      return value;
    } else {
      String value = '여행';
      return value;
    }
  }
}
