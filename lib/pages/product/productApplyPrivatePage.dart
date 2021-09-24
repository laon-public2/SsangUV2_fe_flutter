import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/customAppBar%20copy.dart';
import 'package:share_product_v2/widgets/customdialog.dart';
import 'package:share_product_v2/widgets/customdialogApplyReg.dart';

class ProductApplyPrivatePage extends StatefulWidget {
  final int productIdx;
  final int userIdx;
  final String userPhNum;
  final int Category;
  final String title;
  final int minPrice;
  final int maxPrice;
  final String startDate;
  final String endDate;
  final String address;
  final String addressDetail;
  final num longitude;
  final num latitude;


  const ProductApplyPrivatePage(
      this.productIdx,
      this.userIdx,
      this.userPhNum,
      this.Category,
      this.title,
      this.minPrice,
      this.maxPrice,
      this.startDate,
      this.endDate,
      this.address,
      this.addressDetail,
      this.longitude,
      this.latitude,
      );
  @override
  _ProductApplyPageState createState() => _ProductApplyPageState();
}

class _ProductApplyPageState extends State<ProductApplyPrivatePage> {
  List<String> categories = [
    "생활용품",
    "여행",
    "스포츠/레저",
    "육아",
    "반려동물",
    "가전제품",
    "의류/잡화",
    "가구/인테리어",
    "자동차용품",
    "기타"
  ];

  String _selectedCategory = "";

  bool _otherLocation = false;

  final picker = ImagePicker();

  // Text Controller
  final titleTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  final addressTextController = TextEditingController();
  final dateTextController = TextEditingController();

  // TextField Focus
  late FocusNode titleFocus;
  late FocusNode priceFocus;
  late FocusNode descriptionFocus;

  List<Asset> images = List<Asset>.empty();

  _dateFormat(String date) {
    String formatDate(DateTime date) => new DateFormat("yyyy/MM/dd").format(date);
    return formatDate(DateTime.parse(date));
  }

  @override
  void initState() {
    super.initState();
    titleFocus = FocusNode();
    priceFocus = FocusNode();
    descriptionFocus = FocusNode();
    setState(() {
      this.titleTextController.text = this.widget.title;
      this._selectedCategory = _category(this.widget.Category);
      this.addressTextController.text = "${this.widget.address} ${this.widget.addressDetail}";
      this.dateTextController.text = "${_dateFormat(this.widget.startDate)} ~ ${_dateFormat(this.widget.endDate)}";
    });
  }

  @override
  void dispose() {
    titleFocus.dispose();
    priceFocus.dispose();
    descriptionFocus.dispose();
    super.dispose();
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>.empty();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "쌩유",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Stack(
          children: [
            AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWithPrev(appBar: AppBar(), title: "", elevation: 0.0,),
      body: body(context),
    );
  }

  Widget body(context) {
    return SingleChildScrollView(
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Column(
            children: [
              textFieldForm(context),
            ],
          )),
    );
  }

  Widget textField(String placeholder, TextEditingController controller) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(
          color: Color(0xffdddddd),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        readOnly: true,
        style: TextStyle(fontSize: 14, color: Color(0xff333333)),
        controller: controller,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(fontSize: 14, color: Color(0xffaaaaaa)),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget textFieldPrice(String placeholder, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xffdddddd),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 14, color: Color(0xff333333)),
        controller: controller,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(fontSize: 14, color: Color(0xffaaaaaa)),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget categorySelect() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border.all(color: Color(0xffdddddd)),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 48,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Text(
              _selectedCategory != "" ? _selectedCategory : "카테고리 선택",
              style: TextStyle(
                  fontSize: 14,
                  color:
                      Color(_selectedCategory != "" ? 0xff333333 : 0xffaaaaaa)),
            ),
            Spacer(),
            Icon(Icons.keyboard_arrow_right)
          ],
        ));
  }

  Widget textFieldForm(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '대여 등록',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.h),
        photoApply(),
        SizedBox(
          height: 10,
        ),
        textField("상품명 입력", titleTextController),
        SizedBox(
          height: 10,
        ),
        InkWell(
          child: categorySelect(),
          onTap: () {
            // showModalBottomSheet(context: context, builder: buildBottomSheet);
          },
        ),
        SizedBox(
          height: 10,
        ),
        Text(
            '가격은 ${this.widget.minPrice} ~ ${this.widget.maxPrice} 까지 설정 가능합니다.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xff999999),
            ),
        ),
        textFieldPrice("가격설정", priceTextController),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 10,
        ),
        textField("주소", addressTextController),
        SizedBox(
          height: 10,
        ),
        textField("날짜", dateTextController),
        SizedBox(height: 10),
        description(descriptionTextController),
        SizedBox(
          height: 10,
        ),
        SizedBox(
            height: 40.h,
            width: double.infinity,
            child: Consumer<UserProvider>(
              builder: (_, _user, __) {
                return Consumer<ProductProvider>(
                  builder: (__, _product, _) {
                    return RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async{
                        if(images.length == 0){
                          _showDialog(context, "사진을 등록해주세요.");
                          return;
                        }
                        if (int.parse(priceTextController.text) > this.widget.maxPrice){
                          _showDialog(context, "요청한 가격보다 높습니다.");
                          return;
                        }
                        if (descriptionTextController.text == "") {
                          _showDialog(context, "물품의 자세한 내용 입력해주세요.");
                          return;
                        }
                        await _product.productApplyPrivate(
                          _user.phNum,
                          _user.userIdx,
                          _selectCategory(_selectedCategory),
                          this.widget.productIdx,
                          titleTextController.text,
                          descriptionTextController.text,
                          int.parse(priceTextController.text),
                          images,
                          this.widget.startDate,
                          this.widget.endDate,
                          this.widget.address,
                          this.widget.addressDetail,
                          _user.accessToken,
                          this.widget.latitude,
                          this.widget.longitude,
                        );
                        _showDialogSuccess("글이 등록되었습니다.");
                      },
                      child: Text(
                        "완료",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    );
                  },
                );
              },
            )),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
        // width: MediaQuery.of(context).size.width * 0.7,
      width: 100.w,
        child: SafeArea(
            child: ListView.builder(
          itemBuilder: (context, idx) {
            String category = categories[idx];
            return categoryItem(category);
          },
          itemCount: categories.length,
        )));
  }

  Widget photoApply() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            width: 72,
            height: 72,
            decoration: BoxDecoration(
                color: Color(0xffdddddd),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: InkWell(
              onTap: () async {
                await loadAssets();
              },
              child: Center(child: Icon(Icons.camera_alt)),
            ),
          ),
          Row(
            children: images.map((e) {
              return Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: AssetThumb(
                    asset: e,
                    width: 72,
                    height: 72,
                  ),
                ),
                Positioned(
                  top: -12,
                  right: -6,
                  child: IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        setState(() {
                          images.remove(e);
                        });
                      }),
                )
              ]);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget description(TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xffdddddd)),
        borderRadius: BorderRadius.circular(10),
      ),
      // hack textfield height
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        style: TextStyle(fontSize: 14, color: Color(0xff333333)),
        maxLines: 15,
        controller: controller,
        focusNode: descriptionFocus,
        decoration: InputDecoration(
          hintText: "공유할 물품에 대한 내용을 작성해주세요. (공유불가품목은 게시가 제한될 수 있습니다.)",
          hintStyle: TextStyle(fontSize: 14, color: Color(0xffaaaaaa)),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  void _showDialogSuccess(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApplyReg(Center(child: Text(text)), '확인');
        });
  }

  Widget categoryItem(String title) {
    return SizedBox(
      height: 48.h,
      width: double.infinity,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCategory = title;
          });
          Navigator.of(context).pop();
        },
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: TextStyle(fontSize: 14, color: Color(0xff333333)),
            )),
      ),
    );
  }

  _selectCategory(String category) {
    if (category == "생활용품") {
      return 2;
    }
    if (category == "여행") {
      return 3;
    }
    if (category == "스포츠/레저") {
      return 4;
    }
    if (category == "육아") {
      return 5;
    }
    if (category == "반려동물") {
      return 6;
    }
    if (category == "가전제품") {
      return 7;
    }
    if (category == "의류/잡화") {
      return 8;
    }
    if (category == "가구/인테리어") {
      return 9;
    }
    if (category == "자동차용품") {
      return 10;
    }
    if (category == "기타") {
      return 11;
    }
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

  void _showDialog(context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(dialogChild(message), "확인", () {
            Navigator.of(context).pop();
          });
        });
  }

  Widget dialogChild(String message) {
    return Column(
      children: [
        Text(
          message,
          style: TextStyle(fontSize: 14.sp, color: Color(0xff333333)),
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
}
