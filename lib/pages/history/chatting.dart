import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/pages/chat/CustomerMessage.dart';
import 'package:share_product_v2/providers/contractProvider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/customText.dart';

class Chatting extends StatelessWidget {
  const Chatting({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int page = 0;

    Future<bool> chatListLoad() async {
      await Provider.of<ProductProvider>(context, listen: false).chatList(
        Provider.of<UserProvider>(context, listen: false).userIdx,
        page,
        Provider.of<UserProvider>(context, listen: false).accessToken,
      );
      return false;
    }

    return FutureBuilder(
      future: chatListLoad(),
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
                      if(idx == contracts.chatListItem.length) {
                        if(idx == contracts.chatListCounter.totalCount){
                          return Container();
                        }else{
                          page++;
                          Provider.of<ProductProvider>(context, listen: false).chatList(
                            Provider.of<UserProvider>(context, listen: false).userIdx,
                            page,
                            Provider.of<UserProvider>(context, listen: false).accessToken,
                          );
                        }
                      }
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                CustomerMessage(
                                    contracts.chatListItem[idx].uuid,
                                    contracts.chatListItem[idx].productIdx,
                                    contracts.chatListItem[idx].productTitle,
                                    contracts.chatListItem[idx].status,
                                ),
                            )
                          );
                        },
                        leading: Container(
                          width: 48.w,
                          height: 48.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xffDDDDDD)),
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Image.network(
                            "http://192.168.100.232:5066/assets/images/product/${contracts.chatListItem[idx].productFiles[0].path}",
                            fit: BoxFit.cover,
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
}
