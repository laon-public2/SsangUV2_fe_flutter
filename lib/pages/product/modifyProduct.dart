import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/model/product.dart';
import 'package:share_product_v2/providers/productController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_product_v2/providers/userController.dart';
import 'package:share_product_v2/widgets/customAppBar%20copy.dart';
import 'dart:io';

import 'package:share_product_v2/widgets/customdialog.dart';

class ModifyProduct extends StatefulWidget {
  final Product product;

  ModifyProduct({required this.product});

  @override
  _ModifyProductState createState() => _ModifyProductState();
}

class _ModifyProductState extends State<ModifyProduct> {
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

  final picker = ImagePicker();

  // Text Controller
  final titleTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final descriptionTextController = TextEditingController();

  // TextField Focus
  late FocusNode titleFocus;
  late FocusNode priceFocus;
  late FocusNode descriptionFocus;

  late List<Asset> images = [];

  late List<ProductFile> original_images = [];
  late List<int> deleteImages = [];

  ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    titleFocus = FocusNode();
    priceFocus = FocusNode();
    descriptionFocus = FocusNode();

    titleTextController.text = widget.product.title;
    priceTextController.text = widget.product.price.toString();
    descriptionTextController.text = widget.product.description;
    _selectedCategory = widget.product.category.name;

    original_images = widget.product.productFiles.toList();
  }

  @override
  void dispose() {
    super.dispose();
    titleFocus.dispose();
    priceFocus.dispose();
    descriptionFocus.dispose();
  }

  Future<void> loadAssets() async {
    late List<Asset> resultList = [];
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 8 - original_images.length,
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
      appBar: AppBarWithPrev(appBar: AppBar(), title: "${widget.product.title}", elevation: 1.0,),
      body: body(context),
    );
  }

  Widget body(context) {
    return SingleChildScrollView(
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
          color: Colors.white, border: Border.all(color: Color(0xffdddddd))),
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
            color: Colors.white, border: Border.all(color: Color(0xffdddddd))),
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
            showModalBottomSheet(context: context, builder: buildBottomSheet);
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
        userAddress(),
        SizedBox(
          height: 10,
        ),
        description(descriptionTextController),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 40.h,
          width: double.infinity,
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              print(111);
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

              productController.putProduct(
                  context,
                  widget.product.id,
                  _selectedCategory,
                  titleTextController.text,
                  descriptionTextController.text,
                  int.parse(priceTextController.text),
                  images,
                  deleteImages);
            },
            child: Text(
              "확인",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
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
            children: original_images.map((e) {
              return Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Image.network(
                    "http://ssangu.oig.kr:8080/resources?path=${e.path}",
                    fit: BoxFit.cover,
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
                          original_images.remove(e);
                          deleteImages.add(e.id);
                        });
                      }),
                )
              ]);
            }).toList(),
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
          color: Colors.white, border: Border.all(color: Color(0xffdddddd))),
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

  Widget userAddress() {
    return GetBuilder<UserController>(builder: (user) {
      print(123);
      print(user.loginMember!.member.address);
      return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed("/address");
        },
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xffdddddd))),
          height: 48,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            user.loginMember!.member.address.address ?? "",
            style: TextStyle(fontSize: 14, color: Color(0xff333333)),
          ),
        ),
      );
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

  void _showDialog(context, String message, String type) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(dialogChild(message), "확인", () {
            Navigator.of(context).pop();

            switch (type) {
              case "title":
                // FocusScope.of(context).unfocus();
                // FocusScope.of(context).requestFocus(titleFocus);
                break;
              case "category":
                showModalBottomSheet(
                    context: context, builder: buildBottomSheet);
                break;
              case "price":
                // FocusScope.of(context).requestFocus(priceFocus);
                break;
              case "description":
                // FocusScope.of(context).requestFocus(descriptionFocus);
                break;
            }
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
