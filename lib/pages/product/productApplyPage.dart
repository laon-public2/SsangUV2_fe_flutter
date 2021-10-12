import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/productController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_product_v2/providers/userController.dart';
import 'package:share_product_v2/widgets/CustomDatePicker.dart';
import 'package:share_product_v2/widgets/customAppBar%20copy.dart';
import 'dart:io';

import 'package:share_product_v2/widgets/customdialog.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';
import 'package:share_product_v2/widgets/customdialogApplyReg.dart';
import 'package:share_product_v2/widgets/loading.dart';

import 'ProductReg.dart';

class ProductApplyPage extends StatefulWidget {
  @override
  _ProductApplyPageState createState() => _ProductApplyPageState();
}

class _ProductApplyPageState extends State<ProductApplyPage> with SingleTickerProviderStateMixin {

  ProductController productController = Get.find<ProductController>();
  UserController userController = Get.find<UserController>();

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
  TextEditingController _otherAddressDetail = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  // TextField Focus
  late FocusNode titleFocus;
  late FocusNode priceFocus;
  late FocusNode descriptionFocus;

  late List<Asset> images = [];
  late List<RadioModel> LocationData = [];

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  double _visible = 0.0;

  @override
  void initState() {
    super.initState();
    titleFocus = FocusNode();
    priceFocus = FocusNode();
    descriptionFocus = FocusNode();
    LocationData.add(RadioModel(true, "OnlyMine", "현재 위치"));
    LocationData.add(RadioModel(false, "NormalLocation", "기본 위치"));
    LocationData.add(RadioModel(false, "OtherLocation", "다른 위치"));
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )
      ..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _visible = 1.0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    titleFocus.dispose();
    priceFocus.dispose();
    descriptionFocus.dispose();
  }

  Future<void> loadAssets() async {
    late List<Asset> resultList = [];
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
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
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await productController.resetAddress();
    });
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

  Widget textField(String placeholder, TextEditingController controller,
      TextInputType type, FocusNode focusNode, bool isNumber) {
    final List<TextInputFormatter> formatters = <TextInputFormatter>[];
    if (isNumber) formatters.add(FilteringTextInputFormatter.digitsOnly);

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
        inputFormatters: formatters,
        style: TextStyle(fontSize: 14, color: Color(0xff333333)),
        controller: controller,
        keyboardType: type,
        focusNode: focusNode,
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
          color: Colors.white,
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
        AnimatedOpacity(
          opacity: _visible,
          duration: Duration(milliseconds: 500),
          child: SlideTransition(
            position: _offsetAnimation,
            child: Text(
              '공유상품 등록',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        photoApply(),
        SizedBox(
          height: 10,
        ),
        textField("상품명 입력", titleTextController, TextInputType.text, titleFocus,
            false),
        SizedBox(
          height: 10,
        ),
        InkWell(
          child: categorySelect(),
          onTap: () {
            showModalBottomSheet(context: context, builder: buildBottomSheet, backgroundColor: Colors.transparent);
          },
        ),
        SizedBox(
          height: 10,
        ),
        textField("가격입력 (1일 기준)", priceTextController, TextInputType.number,
            priceFocus, true),
        SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          height: 52,
          child: Row(
            children: [
              //현재 위치
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor:Colors.transparent,
                onTap: () {
                  setState(() {
                    LocationData.forEach(
                            (element) => element.isSelected = false);
                    LocationData[0].isSelected = true;
                  });
                  this._otherLocation = false;
                },
                child: RadioItem(LocationData[0]),
              ),
              //기본 위치
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor:Colors.transparent,
                onTap: () {
                  setState(() {
                    LocationData.forEach(
                            (element) => element.isSelected = false);
                    LocationData[1].isSelected = true;
                  });
                  this._otherLocation = false;
                },
                child: RadioItem(LocationData[1]),
              ),
              //다른 위치
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor:Colors.transparent,
                onTap: () {
                  setState(() {
                    LocationData.forEach(
                            (element) => element.isSelected = false);
                    LocationData[2].isSelected = true;
                  });
                  this._otherLocation = true;
                },
                child: RadioItem(LocationData[2]),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        userAddress("lend2", LocationData[2].isSelected == true ? "true" : "false"),
        SizedBox(height: 10),
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: LocationData[2].isSelected == true ? Colors.white : Colors.grey[300],
            border: Border.all(
              color: Color(0xffdddddd),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            readOnly: LocationData[2].isSelected != true ? true : false,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xffaaaaaa),
            ),
            controller: _otherAddressDetail,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: "기타 자세한 주소",
              hintStyle: TextStyle(
                  fontSize: 14, color: Color(0xffaaaaaa)),
            ),
          ),
        ),
        SizedBox(height: 10),
        CustomDate(controller: _dateController),
        SizedBox(height: 10),
        description(descriptionTextController),
        SizedBox(
          height: 10,
        ),
        SizedBox(
            height: 50.h,
            width: double.infinity,
            child: GetBuilder<UserController>(
              builder: (_user) {
                    return RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async{
                        if (titleTextController.text == "") {
                          _showDialog(context, "제목을 입력해주세요.", "title");
                          return;
                        }

                        if (_selectedCategory == "") {
                          _showDialog(context, "카테고리를 선택해주세요.", "category");
                          return;
                        }

                        if (priceTextController.text == "") {
                          _showDialog(context, "가격을 입력해주세요.", "price");
                          return;
                        }

                        if (descriptionTextController.text == "") {
                          _showDialog(context, "설명을 입력해주세요.", "description");
                          return;
                        }
                        if(this.LocationData[2].isSelected && productController.secondAddress.value == "기타 주소 설정"){
                          _showDialog(context, "기타 주소가 설정되지 않았습니다.", "description");
                        }
                        if(this.LocationData[2].isSelected && _otherAddressDetail.text == ""){
                          _showDialog(context, "기타 자세한 주소가 설정되지 않았습니다.", "description");
                        }
                        _showDialogLoading();
                        List<String> date = _dateController.text.split("~");
                        if(this.LocationData[0].isSelected){
                          await productController.productApplyRent(
                            _user.phNum.value,
                            _user.userIdx.value,
                            _selectCategory(_selectedCategory),
                            titleTextController.text,
                            descriptionTextController.text,
                            int.parse(priceTextController.text),
                            images,
                            date[0],
                            date[1],
                            "${productController.geoLocation[1].depth1} ${productController.geoLocation[1].depth2}",
                            "${productController.geoLocation[1].depth3} ${productController.geoLocation[1].depth4}",
                            productController.lat.value,
                            productController.lon.value,
                            _user.accessToken.value,
                            _otherLocation,
                          );
                          _showDialogSuccess("글이 등록되었습니다.");
                        }else if(this.LocationData[1].isSelected){
                          await productController.productApplyRent(
                            _user.phNum.value,
                            _user.userIdx.value,
                            _selectCategory(_selectedCategory),
                            titleTextController.text,
                            descriptionTextController.text,
                            int.parse(priceTextController.text),
                            images,
                            date[0],
                            date[1],
                            "${_user.address}",
                            "${_user.addressDetail}",
                            _user.userLocationLatitude.value,
                            _user.userLocationLongitude.value,
                            _user.accessToken.value,
                            _otherLocation,
                          );
                          _showDialogSuccess("글이 등록되었습니다.");
                        }else{
                          await productController.productApplyRent(
                            _user.phNum.value,
                            _user.userIdx.value,
                            _selectCategory(_selectedCategory),
                            titleTextController.text,
                            descriptionTextController.text,
                            int.parse(priceTextController.text),
                            images,
                            date[0],
                            date[1],
                            "${productController.secondAddress}",
                            "${this._otherAddressDetail.text}",
                            productController.secondLa.value,
                            productController.secondLo.value,
                            _user.accessToken.value,
                            _otherLocation,
                          );
                          _showDialogSuccess("글이 등록되었습니다.");
                        }
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
            )),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            )
        ),
        width: MediaQuery.of(context).size.width * 0.7,
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
          this.images.length == 3 ?
          SizedBox():
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

  Widget userAddress(String type, String enabled) {
        return InkWell(
          onTap: () {
            if(enabled == "true"){
              if(type == "lend2"){
                setState(() {
                  _otherLocation = true;
                });
                Navigator.of(context).pushNamed(
                  "/address",
                  arguments: {
                    "type": type,
                  },
                );
              }else{
                return;
              }
            }else{
              return;
            }
          },
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: enabled == "true" ? Colors.white : Colors.grey[300],
              border: Border.all(
                color: Color(0xffdddddd),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 48,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              _otherLocation == false
                  ? "${_otherLoc(type)}"
                  : "${_otherLoc(type)}",
              style: TextStyle(fontSize: 14, color: Color(0xffaaaaaa)),
            ),
          ),
        );
  }

  _otherLoc(String type) {
    if (type == "lend1") {
      return productController.firstAddress.value;
    } else {
      return productController.secondAddress.value;
    }
  }

  void _showDialogSuccess(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApplyReg(Center(child: Text(text)), '확인');
        });
  }

  void _showDialogLoading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Loading();
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

  void _showDialog(context, String message, String type) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApply(Center(child: Text(message)), '확인');
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
  // Widget notBack(){
  //   return WillPopScope(
  //       child: Loading(),
  //       onWillPop: () {},
  //   );
  // }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 6,
                color: _item.isSelected ? Color(0xffff0066) : Color(0xff999999),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(_item.text),
          ),
        ],
      ),
    );
  }
}
