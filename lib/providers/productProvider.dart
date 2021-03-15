import 'dart:convert';

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_product_v2/model/CategoryPageRent.dart';
import 'package:share_product_v2/model/CategoryPageWant.dart';
import 'package:share_product_v2/model/Geolocation.dart';
import 'package:share_product_v2/model/MainPageRent.dart';
import 'package:share_product_v2/model/MainPageWant.dart';
import 'package:share_product_v2/model/PrivateRent.dart';
import 'package:share_product_v2/model/ProductDetailWant.dart';
import 'package:share_product_v2/model/ProductReview.dart';
import 'package:share_product_v2/model/ProductReview.dart';
import 'package:share_product_v2/model/Reviewpaging.dart';
import 'package:share_product_v2/model/UserLocationModel.dart';
import 'package:share_product_v2/model/chatListModel.dart';
import 'package:share_product_v2/model/paging.dart';
import 'package:share_product_v2/model/product.dart';
import 'package:share_product_v2/model/searchDataProduct.dart';
import 'package:share_product_v2/model/specialProduct.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/pages/search/searchData.dart';
import 'package:share_product_v2/providers/mainProvider.dart';

import 'package:share_product_v2/services/policyService.dart';
import 'package:share_product_v2/services/productService.dart';
import 'package:share_product_v2/utils/APIUtil.dart';
import 'package:share_product_v2/widgets/customdialogApplyReg.dart';
import 'package:share_product_v2/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService productService = ProductService();

  Paging paging;
  ReviewPaging reviewPaging;
  Paging searchPaging;

  Product product;

  List<Product> products = [];

  List<MainPageRent> mainProducts = [];
  List<MainPageWant> mainProductsWant = [];
  List<CategoryPageRent> categoryProducts = [];
  List<CategoryPageWant> categoryProductsWant = [];
  List<String> myLocation = ["로딩중", "기본주소", "다른 위치 설정"];
  String currentLocation = "";
  List<Geolocation> geoLocation = [];
  List<Geolocation> geoUserLocation = [];
  productDetailWant productDetail;
  List<productReview> productReviewnot;
  List<SearchDataProduct> searchDataProduct = [];
  List<SearchDataProduct> searchDataProductWant = [];
  List<PrivateRent> privateRentList = [];
  Paging privateRentCounter;

  List<ChatListModel> chatListItem = [];
  Paging chatListCounter;
  List<ChatListModel> rentListItem = [];
  Paging rentListCounter;

  String firstAddress = '기본 주소로 사용함';
  String secondAddress = '기타 주소 설정';
  num firstLa;
  num firstLo;
  num secondLa;
  num secondLo;

  String searchingWord;
  num la;
  num lo;
  num laDefault;
  num loDefault;
  num laSecondDefault;
  num loSecondDefault;
  num laUser;
  num loUser;

  List<SpecialProduct> specialProduct = [];

  void resetAddress() {
    this.firstAddress = '기본 주소 설정';
    this.secondAddress = '기타 주소 설정';
    this.firstLa = 0;
    this.firstLo = 0;
    this.secondLa = 0;
    this.secondLo = 0;
    this.laUser = 0;
    this.loUser = 0;
    notifyListeners();
  }

  Future<void> changeUserPosition(num la, num lo) {
    this.laUser = la;
    this.loUser = lo;
    notifyListeners();
  }

  Future<void> changeAddress(
      String type, num la, num lo, String address) async {
    print(type);
    if (type == "lend1") {
      this.firstAddress = address;
      this.firstLa = la;
      this.firstLo = lo;
    } else if (type == "lend2") {
      this.secondAddress = address;
      this.secondLa = la;
      this.secondLo = lo;
    } else {
      this.firstAddress = address;
      this.firstLa = la;
      this.firstLo = lo;
    }
    notifyListeners();
  }

  Future<void> getGeolocator() async {
    this.currentLocation = myLocation.first;
    int page = 0;
    var currentPosition = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    await getGeo(currentPosition.latitude, currentPosition.longitude);
    if (this.laUser != null) {
      await getUserGeo(this.laUser, this.loUser);
    }
    print("la 좌표${currentPosition.latitude}");
    print("lo 좌표${currentPosition.longitude}");
    await getMainRent(page);
    await getMainWant(page);
    await getGeoDrop();
    await getUserGeoDrop();
    notifyListeners();
  }

  Future<void> getGeoDrop() async {
    try {
      myLocation[0] = geoLocation[1].depth3;
      this.currentLocation = myLocation.first;
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> getUserGeoDrop() async {
    try {
      myLocation[1] = geoUserLocation[1].depth3;
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  // TODO: point 기반의 (위치) 데이터 수정 필요
  void getProductByCategory(
      double lati, double longti, int page, String type, int category) async {
    if (page == 0) {
      this.products = [];
    }

    final response = (await productService.getProductByCategory(
        lati, longti, page, category));
    Map<String, dynamic> json = jsonDecode(response.toString());

    try {
      List<Product> list = (json['data']['content'] as List)
          .map((e) => Product.fromJson(e))
          .toList();

      Paging paging = Paging.fromJson(json['data']['paging']);

      this.paging = paging;

      if (paging.currentPage == null || paging.currentPage == 0) {
        this.products = list;
      } else {
        for (var e in list) {
          this.products.add(e);
        }
      }
      notifyListeners();
    } catch (e) {
      print("getProductByCategory Exception : $e");
    }
  }

  // TODO: point 기반의 (위치) 데이터 수정 필요
  void getSearch(
      String keyword, int page, double latitude, double longitude) async {
    if (page == 0) {
      this.products = [];
    }
    final response =
        (await productService.getSearch(keyword, page, latitude, longitude));
    Map<String, dynamic> json = jsonDecode(response.toString());

    try {
      List<Product> list = (json['data']['content'] as List)
          .map((e) => Product.fromJson(e))
          .toList();

      Paging paging = Paging.fromJson(json['data']['paging']);

      this.paging = paging;

      // this.products = list;

      if (paging.currentPage == null || paging.currentPage == 0) {
        this.products = list;
      } else {
        for (var e in list) {
          this.products.add(e);
        }
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void getProduct(int id, BuildContext context) async {
    print("id = ${id}");
    this.product = null;

    final response = await productService.getProduct(id);
    Map<String, dynamic> json = jsonDecode(response.toString());
    print("json = ${json}");
    try {
      Product product = Product.fromJson(json['data']);
      this.product = product;

      print(this.product.productFiles);
      print(this.product.productFiles.length);
      print(this.product.productFiles[0]);

      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      latestProduct(product.id.toString(), product, context);
    }
  }

  void getMyProduct(int page) async {
    if (page == 0) {
      this.products = [];
    }

    final response = await productService.getMyProduct(page);
    Map<String, dynamic> json = jsonDecode(response.toString());

    print(json);

    try {
      List<Product> list = (json['data']['content'] as List)
          .map((e) => Product.fromJson(e))
          .toList();

      Paging paging = Paging.fromJson(json['data']['paging']);

      this.paging = paging;

      // this.products = list;

      if (paging.currentPage == null || paging.currentPage == 0) {
        this.products = list;
      } else {
        for (var e in list) {
          this.products.add(e);
        }
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void postProduct(context, String categoryName, String title,
      String description, int price, List<Asset> files) async {
    FormData formData;
    List<MultipartFile> fileList = [];

    var isLoading = true;
    try {
      // showDialog(
      //     context: context,
      //     barrierColor: Colors.black.withOpacity(0.0),
      //     builder: (BuildContext context) {
      //       return Loading();
      //     });

      formData = FormData.fromMap({});
      for (var file in files) {
        ByteData byteData = await file.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile =
            MultipartFile.fromBytes(imageData, filename: file.name);
        fileList.add(multipartFile);
        MapEntry<String, MultipartFile> entry =
            new MapEntry("files", multipartFile);
        formData.files.add(entry);
      }

      // formData = FormData.fromMap({"files": fileList});

      print(formData.files);

      // formData.files.add(fileList);
      Navigator.of(context).pop();
      Response response = await productService.postProduct(
          categoryName, title, description, price, formData);

      print(response.statusCode);

      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> productApplyRent(
    String userPh,
    int userIdx,
    int categoryIdx,
    String title,
    String description,
    int price,
    List<Asset> files,
    String startDate,
    String endDate,
    String address,
    String addressDetail,
    String token,
    bool otherLocation,
  ) async {
    print("상품등록하기 빌려주기");
    try {
      FormData formData;
      List<MultipartFile> fileList = [];
      formData = FormData.fromMap({});
      for (var file in files) {
        ByteData byteData = await file.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile =
            MultipartFile.fromBytes(imageData, filename: file.name);
        fileList.add(multipartFile);
        // MapEntry<String, MultipartFile> entry =
        // new MapEntry("files", multipartFile);
        // formData.files.add(entry);
      }
      final res = await productService.productAddRent(
        userPh,
        userIdx,
        categoryIdx,
        title,
        description,
        price,
        startDate,
        endDate,
        otherLocation == false
            ? "${this.geoLocation[1].depth1} ${this.geoLocation[1].depth2} ${this.geoLocation[1].depth3} ${this.geoLocation[1].depth4}"
            : address,
        addressDetail,
        otherLocation == false ? this.la : this.firstLa,
        otherLocation == false ? this.lo : this.firstLo,
        token,
        fileList,
      );
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> productApplyPrivate(
    String userPh,
    int userIdx,
    int categoryIdx,
    int productIdx,
    String title,
    String description,
    int price,
    List<Asset> files,
    String startDate,
    String endDate,
    String address,
    String addressDetail,
    String token,
    num la,
    num lo,
  ) async {
    print("상품등록하기 빌려주기");
    try {
      FormData formData;
      List<MultipartFile> fileList = [];
      formData = FormData.fromMap({});
      for (var file in files) {
        ByteData byteData = await file.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile =
            MultipartFile.fromBytes(imageData, filename: file.name);
        fileList.add(multipartFile);
        // MapEntry<String, MultipartFile> entry =
        // new MapEntry("files", multipartFile);
        // formData.files.add(entry);
      }
      final res = await productService.productAddpri(
        userPh,
        userIdx,
        categoryIdx,
        productIdx,
        title,
        description,
        price,
        startDate,
        endDate,
        address,
        addressDetail,
        la,
        lo,
        token,
        fileList,
      );
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> productApplyWant(
    String userPh,
    int userIdx,
    int categoryIdx,
    String title,
    String description,
    int minPrice,
    int maxPrice,
    List<Asset> files,
    String startDate,
    String endDate,
    String address,
    String addressDetail,
    num la,
    num lo,
    String token,
    bool otherLocation,
  ) async {
    print("상품등록하기 빌려주세요.");
    try {
      FormData formData;
      List<MultipartFile> fileList = [];
      formData = FormData.fromMap({});
      for (var file in files) {
        ByteData byteData = await file.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile =
            MultipartFile.fromBytes(imageData, filename: file.name);
        fileList.add(multipartFile);
        // MapEntry<String, MultipartFile> entry =
        // new MapEntry("files", multipartFile);
        // formData.files.add(entry);
      }
      final res = await productService.productAddWant(
        userPh,
        userIdx,
        categoryIdx,
        title,
        description,
        minPrice,
        maxPrice,
        startDate,
        endDate,
        otherLocation == false
            ? "${this.geoLocation[1].depth1} ${this.geoLocation[1].depth2} ${this.geoLocation[1].depth3} ${this.geoLocation[1].depth4}"
            : address,
        addressDetail,
        la,
        lo,
        token,
        fileList,
      );
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
    } catch (e) {
      print(e);
    }
  }

  void putProduct(
      context,
      int id,
      String categoryName,
      String title,
      String description,
      int price,
      List<Asset> files,
      List<int> deleteFiles) async {
    FormData formData;
    List<MultipartFile> fileList = [];

    var isLoading = true;
    try {
      showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.0),
          builder: (BuildContext context) {
            return Loading();
          });

      formData = FormData.fromMap({});
      for (var file in files) {
        ByteData byteData = await file.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile multipartFile =
            MultipartFile.fromBytes(imageData, filename: file.name);
        fileList.add(multipartFile);
        MapEntry<String, MultipartFile> entry =
            new MapEntry("files", multipartFile);
        formData.files.add(entry);
      }

      print(formData.files);
      Navigator.of(context).pop();

      Response response = await productService.putProduct(
          id, categoryName, title, description, price, formData, deleteFiles);

      print(response.statusCode);
      Navigator.of(context).pop();

      Map<String, dynamic> json = jsonDecode(response.toString());

      Product product = Product.fromJson(json['data']);

      this.product = product;

      notifyListeners();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void getSpecialProduct() async {
    final response = (await productService.getSpecialProduct());
    Map<String, dynamic> json = jsonDecode(response.toString());
    try {
      // print("json = $json");
      List<SpecialProduct> list = (json['data'] as List)
          .map((e) => SpecialProduct.fromJson(e))
          .toList();
      this.specialProduct = list;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void deleteProduct(context, int id) async {
    try {
      await productService.deleteProduct(id);

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      print(e);
    }
  }

  latestProduct(String idx, Product product, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> idxList = pref.getStringList("idxs");
    if (idxList == null) idxList = List<String>();

    if (idxList.contains(idx)) {
      idxList.remove(idx);
      pref.remove(idx);
    }
    if (idxList.length >= 8) {
      String deleteIdx = idxList.removeLast();
      pref.remove(deleteIdx);
    }

    idxList.insert(0, idx);
    String encode = json.encode(product.toJson());

    pref.setString(idx, encode);
    pref.setStringList("idxs", idxList);

    Provider.of<MainProvider>(context, listen: false).notify();
  }

  renting(int id) async {
    await productService.rentingProduct(id);
    getMyProduct(0);
    notifyListeners();
  }

  rentable(int id) async {
    await productService.rentableProduct(id);
    getMyProduct(0);
    notifyListeners();
  }

  stop(int id) async {
    await productService.stopProduct(id);
    getMyProduct(0);
    notifyListeners();
  }

  Future<void> getMainRent(int page) async {
    if (page == 0) {
      this.mainProducts = [];
    }
    print("메인페이지 상품 로딩");
    final res = await productService.getMainRent(this.la, this.lo, page);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    try {
      print(jsonMap['data']);
      print("에러찾기");
      List<MainPageRent> list = (jsonMap['data'] as List)
          .map((e) => MainPageRent.fromJson(e))
          .toList();
      print("에러찾기");
      Paging paging = Paging.fromJson(jsonMap);
      this.paging = paging;
      if (paging.currentPage == null || paging.currentPage == 0) {
        this.mainProducts = list;
      } else {
        for (var e in list) {
          this.mainProducts.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> getMainWant(int page) async {
    if (page == 0) {
      this.mainProductsWant = [];
    }
    print("메인페이지 상품 로딩 빌려주세요.");
    final res = await productService.getMainWant(this.la, this.lo, page);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    try {
      print("에러찾기");
      List<MainPageWant> list = (jsonMap['data'] as List)
          .map((e) => MainPageWant.fromJson(e))
          .toList();
      print("에러찾기");
      Paging paging = Paging.fromJson(jsonMap);
      this.paging = paging;
      if (paging.currentPage == null || paging.currentPage == 0) {
        this.mainProductsWant = list;
      } else {
        for (var e in list) {
          this.mainProductsWant.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void categoryRent(String category, int page, String type) async {
    print(category);
    print(page);
    print(type);
    print(la);
    print(lo);
    if (page == 0) {
      this.categoryProducts = [];
    }
    print("카테고리 물품 로딩");
    final res = await productService.getCategoryProducts(
        category, page, type, la.toDouble(), lo.toDouble());
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap.toString());
    try {
      List<CategoryPageRent> list = (jsonMap['data'] as List)
          .map((e) => CategoryPageRent.fromJson(e))
          .toList();
      Paging paging = Paging.fromJson(jsonMap);
      this.paging = paging;
      if (this.paging.currentPage == null || this.paging.currentPage == 0) {
        this.categoryProducts = list;
        print(this.categoryProducts);
      } else {
        for (var e in list) {
          this.categoryProducts.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void categoryWant(
      String category, int page, String type, num lati, num longti) async {
    if (page == 0) {
      this.categoryProductsWant = [];
    }
    print("카테고리 물품 로딩");
    final res = await productService.getCategoryProducts(
        category, page, type, lati, longti);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap.toString());
    try {
      List<CategoryPageWant> list = (jsonMap['data'] as List)
          .map((e) => CategoryPageWant.fromJson(e))
          .toList();
      Paging paging = Paging.fromJson(jsonMap);
      this.paging = paging;
      if (this.paging.currentPage == null || this.paging.currentPage == 0) {
        this.categoryProductsWant = list;
        print(this.categoryProducts);
      } else {
        for (var e in list) {
          this.categoryProductsWant.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> getproductDetail(int productIdx, var lati, var longti) async {
    print(productIdx);
    print(lati);
    print(longti);
    print("물품 상세정보 로딩");
    this.productDetail = null;
    final res = await productService.productDetail(productIdx, la, lo);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);
    try {
      productDetailWant list = productDetailWant.fromJson(jsonMap['data']);
      this.productDetail = list;
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> getProductReviewFive(int productIdx, int page) async {
    print("물품 리뷰 가져오기");
    if (page == 0) {
      this.productReviewnot = null;
    }
    final res = await productService.productReview(productIdx, page);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);
    try {
      print("에러체크");
      List<productReview> list = (jsonMap['data'] as List)
          .map((e) => productReview.fromJson(e))
          .toList();
      print("에러체크");
      ReviewPaging paging = ReviewPaging.fromJson(jsonMap);
      this.reviewPaging = paging;
      if (this.reviewPaging.currentPage == null ||
          this.reviewPaging.currentPage == 0) {
        this.productReviewnot = list;
        print(list[0].createAt);
      } else {
        for (var e in list) {
          this.productReviewnot.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> sendReview(int userIdx, int productIdx, String description,
      int grade, String token) async {
    print("리뷰보내기");
    final res = await productService.sendReview(
        userIdx, productIdx, description, grade, token);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);
  }

  Future<void> getGeoSearch(num la, num long) async {
    print("설정한 주소 설정");
    int page = 0;
    this.laSecondDefault = la;
    this.loSecondDefault = long;
    final res = await productService.getGeo(la, long);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    List<Geolocation> list = (jsonMap['documents'] as List)
        .map((e) => Geolocation.fromJson(e))
        .toList();
    if (this.myLocation[2] == "다른 위치 설정") {
      this.myLocation.add('다른 위치 설정');
    }
    this.myLocation[2] = "${list[1].depth3}";
    this.currentLocation = "${list[1].depth3}";
    this.la = la;
    this.lo = long;
    await getMainRent(page);
    await getMainWant(page);
    notifyListeners();
  }

  Future<void> getGeoChange(String value) async {
    try {
      int page = 0;
      if (this.myLocation[0] == value) {
        this.la = this.laDefault;
        this.lo = this.loDefault;
        this.currentLocation = value;
        await getMainRent(page);
        await getMainWant(page);
      } else if (this.myLocation[1] == value) {
        this.myLocation[1] = value;
        this.currentLocation = value;
        this.la = this.laUser;
        this.lo = this.loUser;
        await getMainRent(page);
        await getMainWant(page);
      } else {
        this.myLocation[2] = value;
        this.currentLocation = value;
        this.la = this.laSecondDefault;
        this.lo = this.loSecondDefault;
        await getMainRent(page);
        await getMainWant(page);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> getGeo(num la, num long) async {
    print('위치 정보 조회');
    this.la = la;
    this.lo = long;
    this.laDefault = la;
    this.loDefault = long;
    final res = await productService.getGeo(la, long);
    print(res.toString());
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);
    List<Geolocation> list = (jsonMap['documents'] as List)
        .map((e) => Geolocation.fromJson(e))
        .toList();
    this.geoLocation = list;
    notifyListeners();
  }

  Future<void> getUserGeo(num la, num long) async {
    print('유저 위치 정보 조회');
    final res = await productService.getGeo(la, long);
    Map<String, dynamic> jsonMap = json.decode(res.toString());
    print(jsonMap);
    List<Geolocation> list = (jsonMap['documents'] as List)
        .map((e) => Geolocation.fromJson(e))
        .toList();
    this.geoUserLocation = list;
    notifyListeners();
  }

  Future<void> SearchingDataProduct(
      int page, String searchData, int category) async {
    print(page);
    print(searchData);
    print(category);
    print('검색 조회 프로바이더 서비스');
    if (page == 0) {
      this.searchDataProduct = [];
    }
    try {
      final res = await productService.searchProduct(
          page, searchData, la, lo, category);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      List<SearchDataProduct> list = (jsonMap['data'] as List)
          .map((e) => SearchDataProduct.fromJson(e))
          .toList();
      print(list);
      Paging paging = Paging.fromJson(jsonMap);
      this.searchPaging = paging;
      if (this.searchPaging.currentPage == null ||
          this.searchPaging.currentPage == 0) {
        this.searchDataProduct = list;
      } else {
        for (var e in list) {
          this.searchDataProduct.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> delProduct(int productIdx, String token) async {
    print("물품 삭제 프로바이더");
    try {
      final res = await productService.delProduct(productIdx, token);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      print(jsonMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> privateList(int productIdx, int page, String token) async {
    print("유저 대여 제공리스트");
    try {
      final res =
          await productService.privateList(productIdx, la, lo, page, token);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      List<PrivateRent> list = (jsonMap['data'] as List)
          .map((e) => PrivateRent.fromJson(e))
          .toList();
      print(list);
      Paging paging = Paging.fromJson(jsonMap);
      this.privateRentCounter = paging;
      if (this.privateRentCounter.currentPage == null ||
          this.privateRentCounter.currentPage == 0) {
        this.privateRentList = list;
      } else {
        for (var e in list) {
          this.privateRentList.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> chatList(int userIdx, int page, String token) async {
    print("챗 서비스 프로바이더");
    try {
      final res = await productService.chatList(userIdx, page, token);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      List<ChatListModel> list = (jsonMap['data'] as List)
          .map((e) => ChatListModel.fromJson(e))
          .toList();
      print(list);
      Paging paging = Paging.fromJson(jsonMap);
      this.chatListCounter = paging;
      if(this.chatListCounter.currentPage == null || this.chatListCounter.currentPage == 0) {
        this.chatListItem = list;
      }else {
        for(var e in list) {
          this.chatListItem.add(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> rentHistory(int userIdx, int page, String token) async{
    print("렌트 히스토리");
    try{
      final res = await productService.rentHistory(userIdx, page, token);
      Map<String, dynamic> jsonMap = json.decode(res.toString());
      List<ChatListModel> list = (jsonMap['data'] as List)
          .map((e) => ChatListModel.fromJson(e))
          .toList();
      print(list);
      Paging paging = Paging.fromJson(jsonMap);
      this.rentListCounter = paging;
      if(this.rentListCounter.currentPage == null || this.rentListCounter.currentPage == 0) {
        this.rentListItem = list;
      }else {
        for(var e in list) {
          this.rentListItem.add(e);
        }
      }
    }catch(e){
      print(e);
    }
  }
}
