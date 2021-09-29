import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/providers/userProvider.dart';
import 'package:share_product_v2/widgets/CustomDatePicker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:math';
import 'package:share_product_v2/widgets/CustomOnlyInputFieldContainer.dart';
import 'package:share_product_v2/consts/textStyle.dart';
import 'package:share_product_v2/widgets/customdialogApply.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:share_product_v2/widgets/customdialogApplyReg.dart';
import 'package:share_product_v2/widgets/loading.dart';

class ProductReg extends StatefulWidget {
  @override
  _ProductRegState createState() => _ProductRegState();
}

class _ProductRegState extends State<ProductReg> with SingleTickerProviderStateMixin {
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

  // var maskComNumFomatter = new MaskTextInputFormatter(
  //     mask: '###,###,###,###,###,###,###,###,###',
  //     filter: {'#': RegExp(r'[0-9]')});
  TextEditingController _controller = TextEditingController();
  TextEditingController _productName = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _minMoneyController = TextEditingController();
  TextEditingController _otherAddressDetail = TextEditingController();
  final descriptionTextController = TextEditingController();

  // String _minMoney;
  // String _maxMoney;
  TextEditingController _maxMoneyController = TextEditingController();

  bool _otherLocation = false;

  late List<RadioModel> LocationData = []; //커스텀 라디오 버튼
  late FocusNode descriptionFocus = new FocusNode();

  late AnimationController _aniController;
  late Animation<Offset> _offsetAnimation;
  double _visible = 0.0;

  @override
  void initState() {
    //지금 위젯이 처음 시작할 때부터 2개 자동 추가
    super.initState();
    LocationData.add(RadioModel(true, "OnlyMine", "현재 위치"));
    LocationData.add(RadioModel(false, "NormalLocation", "기본 위치"));
    LocationData.add(RadioModel(false, "OtherLocation", "다른 위치"));
    //애니메이션
    _aniController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset> (
      begin: Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _aniController,
      curve: Curves.fastOutSlowIn,
    ));
    Future.delayed(Duration(milliseconds: 100), (){
      setState(() {
        _visible = 1.0;
      });
    });
  }

  String? _isDialogText;
  final picker = ImagePicker();
  late List<Asset> images = [];

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

  String? adressType;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await Provider.of<ProductProvider>(context, listen: false).resetAddress();
    });
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
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
                      duration: Duration(milliseconds: 500),
                      opacity: _visible,
                      child: SlideTransition(
                        position: _offsetAnimation,
                        child: Text(
                          '상품요청하기',
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
                            context: context, builder: buildBottomSheet, backgroundColor: Colors.transparent);
                      },
                    ),
                    SizedBox(height: 10),
                    CustomDate(
                      controller: _dateController,
                    ),
                    SizedBox(height: 10),
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
                    Container(
                      width: double.infinity,
                      height: 52,
                      child: Row(
                        children: [
                          //현재 위치
                          InkWell(
                            splashColor: Color(0xffff0066),
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
                            splashColor: Color(0xffff0066),
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
                            splashColor: Color(0xffff0066),
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
                            "대여 받으실 때 물품을 수령한 직후 물품의 사진을 촬영해 채팅방에 업로드 해야 합니다. 물품 상태를 확인받지 않을 시 불이익이 따를 수 있습니다.",
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
            child: Consumer<UserProvider> (
              builder: (_, _user, __) {
                return Consumer<ProductProvider>(
                  builder: (_, _myProduct, __) {
                    return InkWell(
                      onTap: () async{
                        if (_productName.text == "") {
                          setState(() {
                            _isDialogText = "상품명이 입력되지 않았습니다.";
                          });
                          _showDialog();
                        }else if (images.length == 0) {
                          setState(() {
                            _isDialogText = "사진이 비어있습니다.";
                          });
                          _showDialog();
                        }else if (_dateController.text == "") {
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
                        }else if (_selectedCategory == "") {
                          setState(() {
                            _isDialogText = "카테고리가 선택되지 않았습니다.";
                          });
                          _showDialog();
                        } else if (this.LocationData[2].isSelected && _myProduct.secondAddress == "기타 주소 설정") {
                            setState(() {
                              _isDialogText = "기타주소가 비어 있습니다.";
                            });
                            _showDialog();
                        } else if(this.LocationData[2].isSelected && _otherAddressDetail.text == ""){
                            setState(() {
                              _isDialogText = "기타 자세한 주소가 비어 있습니다.";
                            });
                            _showDialog();
                        } else if (descriptionTextController.text == "") {
                          setState(() {
                            _isDialogText = "설명글이 비어 있습니다.";
                          });
                          _showDialog();
                        } else {
                          _showDialogLoading();
                          if(this.LocationData[0].isSelected == true){
                            List<String> date = _dateController.text.split("~");
                            await _myProduct.productApplyWant(
                              _user.phNum!,
                              _user.userIdx!,
                              _selectCategory(_selectedCategory),
                              _productName.text,
                              descriptionTextController.text,
                              int.parse(_minMoneyController.text),
                              int.parse(_maxMoneyController.text),
                              images,
                              date[0],
                              date[1],
                              "${_myProduct.geoLocation[1].depth1} ${_myProduct.geoLocation[1].depth2}",
                              "${_myProduct.geoLocation[1].depth3} ${_myProduct.geoLocation[1].depth4}",
                              _myProduct.la,
                              _myProduct.lo,
                              _user.accessToken!,
                              _otherLocation,
                            );
                            _showDialogSuccess("글이 등록되었습니다.");
                          }else if(this.LocationData[1].isSelected == true){
                            List<String> date = _dateController.text.split("~");
                            await _myProduct.productApplyWant(
                              _user.phNum!,
                              _user.userIdx!,
                              _selectCategory(_selectedCategory),
                              _productName.text,
                              descriptionTextController.text,
                              int.parse(_minMoneyController.text),
                              int.parse(_maxMoneyController.text),
                              images,
                              date[0],
                              date[1],
                              "${_user.address}",
                              "${_user.addressDetail}",
                              _user.userLocationX,
                              _user.userLocationY,
                              _user.accessToken!,
                              _otherLocation,
                            );
                            _showDialogSuccess("글이 등록되었습니다.");
                          }else if(this.LocationData[2].isSelected == true){
                            List<String> date = _dateController.text.split("~");
                            await _myProduct.productApplyWant(
                              _user.phNum!,
                              _user.userIdx!,
                              _selectCategory(_selectedCategory),
                              _productName.text,
                              descriptionTextController.text,
                              int.parse(_maxMoneyController.text),
                              int.parse(_minMoneyController.text),
                              images,
                              date[0],
                              date[1],
                              "${_myProduct.secondAddress}",
                              "${this._otherAddressDetail.text}",
                              _myProduct.secondLa,
                              _myProduct.secondLo,
                              _user.accessToken!,
                              _otherLocation,
                            );
                            _showDialogSuccess("글이 등록되었습니다.");
                          }
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
                              '요청하기',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ),
        ],
      ),
    );
  }

  Widget userAddress(String type, String enabled) {
    return Consumer<ProductProvider>(
      builder: (_, _product, __) {
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
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            )
        ),
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
        style: TextStyle(fontSize: 14, color: Color(0xff333333)),
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
          return CustomDialogApply(Center(child: Text(_isDialogText!)), '확인');
        });
  }

  _moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }
  }

  void _showDialogLoading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Loading();
        });
  }

  void _showDialogSuccess(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogApplyReg(Center(child: Text(text)), '확인');
        });
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
}

//여기서부터는 커스텀 라디오 버튼
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

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}

// class GeoLocatorService {
//   Future<Position> getLocation() async {
//     Position position =
//         await getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
//     return position;
//   }
// }
