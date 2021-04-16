import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/model/ProductDetailWant.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/CustomDatePicker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:math';
import 'package:share_product_v2/widgets/CustomOnlyInputFieldContainer.dart';
import 'package:share_product_v2/consts/textStyle.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:geolocator/geolocator.dart';
import 'package:share_product_v2/widgets/customdialogApplyReg.dart';

class ProductModified extends StatefulWidget {
  final productDetailWant originalInfo;
  final String categoryString;

  ProductModified({this.originalInfo, this.categoryString});

  @override
  _ProductRegState createState() => _ProductRegState();
}

class _ProductRegState extends State<ProductModified> with SingleTickerProviderStateMixin{

  //애니메이션
  AnimationController _animationController;
  Animation<Offset> _offsetAnimaiton;
  double _visible = 0.0;

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
  TextEditingController _controller = TextEditingController();
  TextEditingController _productName = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _minMoneyController = TextEditingController();
  TextEditingController _maxMoneyController = TextEditingController();
  TextEditingController _otherAddressDetail = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  bool _otherLocation = false;
  FocusNode descriptionFocus;

  List<ProductFile> original_images = List<ProductFile>();
  List<int> deleteImages = List<int>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _productName.text = this.widget.originalInfo.title;
      _selectedCategory = this.widget.categoryString;
      _priceController.text = "${this.widget.originalInfo.price}";
      _dateController.text =
      "${_dateFormat(this.widget.originalInfo.startDate)} ~ ${_dateFormat(this.widget.originalInfo.endDate)}";
      _minMoneyController.text = "${this.widget.originalInfo.minPrice}";
      _maxMoneyController.text = "${this.widget.originalInfo.maxPrice}";
      descriptionTextController.text = this.widget.originalInfo.description;
      original_images = this.widget.originalInfo.productFiles.toList();
      _otherAddressDetail.text = this.widget.originalInfo.addressDetail;
    });
    //애니메이션
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _offsetAnimaiton = Tween<Offset>(
      begin: Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));
    Future.delayed(Duration(milliseconds: 100), (){
      setState(() {
        _visible = 1.0;
      });
    });
  }

  String _isDialogText;
  final picker = ImagePicker();
  List<Asset> images = List<Asset>();

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3 - original_images.length,
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

  Widget photoApply() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          original_images.length == 3 ?
          SizedBox() :
          Container(
            margin: const EdgeInsets.only(right: 15),
            width: 72,
            height: 72,
            decoration: BoxDecoration(
                color: Color(0xffdddddd),
                borderRadius: BorderRadius.all(Radius.circular(10))),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      "http://115.91.73.66:15066/assets/images/product/${e.path}",
                      fit: BoxFit.cover,
                      width: 72,
                      height: 72,
                    ),
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

  String adressType;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<ProductProvider>(context, listen: false).changeAddress(
        "lend1",
        this.widget.originalInfo.lati,
        this.widget.originalInfo.longti,
        this.widget.originalInfo.address,
      );
    });
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Transform.rotate(
          angle: 180 * pi / 180,
          child: IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AnimatedOpacity(
                      opacity: _visible,
                      duration: Duration(milliseconds: 500),
                      child: SlideTransition(
                        position: _offsetAnimaiton,
                        child: Text(
                          '상품수정하기',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    photoApply(),
                    SizedBox(height: 20),
                    CustomTextFieldContainer(
                        title: '상품명 입력', controller: _productName),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      child: categorySelect(),
                      onTap: () {
                        showModalBottomSheet(
                            context: context, builder: buildBottomSheet);
                      },
                    ),
                    SizedBox(height: 10),
                    CustomDate(
                      controller: _dateController,
                    ),
                    SizedBox(height: 10),
                    this.widget.originalInfo.type == "RENT" ?
                    textField(
                      "가격입력 (1일 기준)",
                      _priceController,
                      TextInputType.number,
                      true,
                    ) :
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Color(0xffdddddd),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: _minMoneyController,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffaaaaaa),
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  hintText: "최저가격",
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Color(0xffaaaaaa)),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "~",
                                  style: normal_14_primary,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Color(0xffdddddd),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffaaaaaa),
                                ),
                                controller: _maxMoneyController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  hintText: "최대가격",
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Color(0xffaaaaaa)),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    userAddress("lend1"),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xffdddddd),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
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
                          hintStyle:
                              TextStyle(fontSize: 14, color: Color(0xffaaaaaa)),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(height: 10),
                    description(descriptionTextController),
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 52,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.priority_high,
                                          size: 14,
                                          color: Color(0xff444444),
                                        ),
                                      ),
                                      TextSpan(
                                          text: "주의",
                                          style: TextStyle(
                                              color: Color(0xff444444))),
                                    ],
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                          Text(
                            "글을 수정 후 다시 이전 글로 되돌릴 수 없습니다. 수정 후 문제가 생기면 쌩유 고객센터로 문의 해주시기 바랍니다.",
                            style: TextStyle(
                              color: Color(0xff444444),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Consumer<UserProvider>(
                builder: (_, _user, __) {
                  return Consumer<ProductProvider>(
                    builder: (_, _myProduct, __) {
                      return InkWell(
                        onTap: () async {
                          if (_productName.text == "") {
                            setState(() {
                              _isDialogText = "상품명이 입력되지 않았습니다.";
                            });
                            _showDialog();
                          } else if (images.length == 0 && original_images.length == 0) {
                            setState(() {
                              _isDialogText = "사진이 비어있습니다.";
                            });
                            _showDialog();
                          } else if (_dateController.text == "") {
                            setState(() {
                              _isDialogText = "기간이 설정되지 않았습니다.";
                            });
                            _showDialog();
                          } else if (_minMoneyController.text == "") {
                            setState(() {
                              _isDialogText = "최저가격이 설정되지 않았습니다.";
                            });
                            _showDialog();
                          } else if (_maxMoneyController.text == "") {
                            setState(() {
                              _isDialogText = "최대가격이 설정되지 않았습니다.";
                            });
                            _showDialog();
                          } else if (_otherLocation == true) {
                            if (_myProduct.secondAddress == "기타 주소 설정") {
                              setState(() {
                                _isDialogText = "기타주소가 비어 있습니다.";
                              });
                              _showDialog();
                            } else if (_otherAddressDetail.text == "") {
                              setState(() {
                                _isDialogText = "기타 자세한 주소가 비어 있습니다.";
                              });
                              _showDialog();
                            }
                          } else if (_selectedCategory == "") {
                            setState(() {
                              _isDialogText = "카테고리가 선택되지 않았습니다.";
                            });
                            _showDialog();
                          } else if (descriptionTextController.text == "") {
                            setState(() {
                              _isDialogText = "설명글이 비어 있습니다.";
                            });
                            _showDialog();
                          } else {
                            List<String> date = _dateController.text.split("~");
                            await _myProduct.productModified(
                                this.widget.originalInfo.id,
                                _selectCategory(this.widget.categoryString),
                                _productName.text,
                                descriptionTextController.text,
                                int.parse(_priceController.text),
                                int.parse(_minMoneyController.text),
                                int.parse(_maxMoneyController.text),
                                images,
                                deleteImages,
                                date[0],
                                date[1],
                                _myProduct.firstAddress,
                                this._otherAddressDetail.text,
                                _myProduct.firstLa,
                                _myProduct.firstLo,
                                _user.accessToken,
                            );
                            _showDialogSuccess("글이 수정되었습니다.");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Color(0xffff0066),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(4, 4),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  color: Colors.black.withOpacity(0.08),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '수정하기',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget userAddress(String type) {
    return Consumer<ProductProvider>(
      builder: (_, _product, __) {
        return InkWell(
          onTap: () {
            setState(() {
              _otherLocation = true;
            });
            Navigator.of(context).pushNamed(
              "/address",
              arguments: {
                "type": type,
              },
            );
          },
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
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
      },
    );
  }

  _otherLoc(String type) {
    if (type == "lend1") {
      return Provider.of<ProductProvider>(context, listen: false).firstAddress;
    } else {
      return Provider.of<ProductProvider>(context, listen: false).secondAddress;
    }
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
        style: TextStyle(fontSize: 14, color: Color(0xffaaaaaa)),
        maxLines: 15,
        controller: controller,
        focusNode: descriptionFocus,
        decoration: InputDecoration(
          hintText: "요청할 물품에 대한 내용을 작성해주세요. (공유 및 요청 불가품목은 게시가 제한될 수 있습니다.)",
          hintStyle: TextStyle(fontSize: 14, color: Color(0xffaaaaaa)),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
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

  //카테고리 선택 위젯
  Widget categorySelect() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0xffdddddd),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 50.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Text(
              _selectedCategory != "" ? _selectedCategory : "카테고리 선택",
              style: TextStyle(
                  fontSize: 14,
                  color:
                      Color(_selectedCategory != "" ? 0xffaaaaaa : 0xffaaaaaa)),
            ),
            Spacer(),
            Icon(Icons.keyboard_arrow_right)
          ],
        ));
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApply(Center(child: Text(_isDialogText)), '확인');
        });
  }

  _dateFormat(String date) {
    String formatDate(DateTime date) =>
        new DateFormat("yyyy-MM-dd").format(date);
    return formatDate(DateTime.parse(date));
  }

  void _showDialogSuccess(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApplyReg(Center(child: Text(text)), '확인');
        });
  }

  //카테고리 숫자 변환기
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
}

Widget textField(String placeholder, TextEditingController controller,
    TextInputType type, bool isNumber) {
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
      style: TextStyle(fontSize: 14, color: Color(0xffaaaaaa)),
      controller: controller,
      keyboardType: type,
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
