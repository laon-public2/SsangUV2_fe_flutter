import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_product_v2/widgets/PrivateRentItem.dart';
import 'package:share_product_v2/widgets/customAppBar%20copy.dart';

class MySSangU extends StatefulWidget {
  final int productIdx;

  MySSangU(this.productIdx);

  @override
  _MySSangUState createState() => _MySSangUState();
}

class _MySSangUState extends State<MySSangU> {
  int page = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _privateListLoad() async {
    await Provider.of<ProductProvider>(context, listen: false).privateList(
      this.widget.productIdx,
      this.page,
      Provider.of<UserProvider>(context, listen: false).accessToken,
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: FutureBuilder(
        future: _privateListLoad(),
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
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              ),
            );
          } else {
            return _body();
          }
        },
      ),
    );
  }

  _appBar() {
    return AppBarWithPrev(appBar: AppBar(), title: "빌려줄게요", elevation: 1.0,);
  }

  _body() {
    return Consumer<ProductProvider>(
      builder: (_, _product, __) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(right: 16, left: 16, top: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '대여요청 답글이 왔어요.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15.h),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, idx) {
                    return PrivateRentItem(
                      category: "${_category(_product.privateRentList[idx].category)}",
                      idx: _product.privateRentList[idx].id,
                      title: "${_product.privateRentList[idx].title}",
                      name: "${_product.privateRentList[idx].name}",
                      price: "${_moneyFormat("${_product.privateRentList[idx].price}")}원",
                      distance:
                      "${(_product.privateRentList[idx].distance).toStringAsFixed(2)}",
                      picture: "${_product.privateRentList[idx].productFiles[0].path}",
                    );
                  },
                  separatorBuilder: (context, idx) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Divider(),
                    );
                  },
                  itemCount: _product.privateRentList.length,
                ),
              ],
            ),
          ),
        );
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

  _moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }
  }
}
