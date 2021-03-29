import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:share_product_v2/model/MainPageRent.dart';
import 'package:share_product_v2/model/product.dart';
import 'package:share_product_v2/model/productMyActRent.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/providers/productProvider.dart';
import 'package:share_product_v2/utils/APIUtil.dart';

class ProductService {
  Dio dio = ApiUtils.instance.dio;

  Future<Map<String, dynamic>> addWantProduct(
    String token,
    String phNum,
    String userIdx,
    String categoryIdx,
    String title,
    String description,
    String price,
    String minPrice,
    String maxPrice,
    String type,
    String address,
    String address_detail,
    String latitude,
    String longitude,
    List<File> sendPic,
  ) async {
    print("상품요청부분");
    FormData data = FormData.fromMap({
      "username": "전화번호",
      "userIdx": "유저 고유 idx",
      "categoryIdx": "카테고리번호",
      "title": "제목",
      "description": "상세내용",
      "price": "가격",
      "minPrice": "최소가격",
      "maxPrice": "최대가격",
      "count": "1",
      "type": "빌려드려요? 아님 딴거",
      "address": "서울시 금천구 가산동",
      "address_detail": "자세한 주소",
      "latitude": "위도",
      "longitude": "경도",
      // for(int i=0; i<sendPic.length; i++){
      //   "productImg" : await MultipartFile.fromFile(
      //     sendPic[i].path,
      //     filename: "MuJacWeeeee",
      //   ),
      // }
      // "productImg": await MultipartFile.fromFile(
      //   sendPic.path,
      //   filename: "MuJacWeeeee",
      // ),
    });
    dio.options.headers['x-access-token'] = token;
    Response res = await dio.post('/product/add', data: {});
  }

  Future<Response> searchProduct(
      int page, String searchData, num lati, num longti, num category) async {
    print("검색 조회 서비스");
    try {
      dio.options.contentType = "application/x-www-form-urlencoded";
      Response res = await dio.get('/product/list', queryParameters: {
        'category': category,
        'page': page,
        'type': "Rent",
        'search': searchData,
        'latitude': lati,
        'longitude': longti,
      });
      return res;
    } on DioError catch (e) {
      print("검색조회 서비스 접속 에러");
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> getProduct(int id) async {
    Response response = await dio.get("/products/$id");
    return response;
  }

  Future<Response> getProductByCategory(
      double lati, double longti, int page, int category) async {
    Response response = await dio.get("/product/list", queryParameters: {
      'category': category,
      'page': page,
      'type': 'Want',
      'search': "",
      "latitude": lati,
      'longitude': longti,
    });

    return response;
  }

  Future<Response> getSearch(
      String keyword, int page, double latitude, double longitude) async {
    Response response = await dio.get("/products/search", queryParameters: {
      "keyword": keyword,
      "page": page,
      "latitude": latitude,
      "longitude": longitude
    });

    return response;
  }

  Future<Response> postProduct(String categoryName, String title,
      String description, int price, FormData formData) async {
    Response response = await dio.post("/products",
        queryParameters: {
          "categoryName": categoryName,
          "title": title,
          "description": description,
          "price": price,
          "dateCount": 1
        },
        data: formData);

    return response;
  }

  Future<Response> getSpecialProduct() async {
    Response response = await dio.get("/products/special");

    return response;
  }

  Future<Response> getMyProduct(int page) async {
    Response response =
        await dio.get("/members/product", queryParameters: {"page": page});

    return response;
  }

  Future<Response> deleteProduct(int id) async {
    Response response = await dio.delete("/products/$id");

    return response;
  }

  Future<Response> putProduct(
      int id,
      String categoryName,
      String title,
      String description,
      int price,
      FormData formData,
      List<int> deleteFiles) async {
    Response response = await dio.put("/products/${id}",
        queryParameters: {
          "categoryName": categoryName,
          "title": title,
          "description": description,
          "price": price,
          "dateCount": 1,
          "deleteFiles": deleteFiles.join(","),
        },
        data: formData);

    return response;
  }

  //
  Future<Response> rentingProduct(int id) async {
    Response response = await dio.patch("/products/renting/$id");
    return response;
  }

  Future<Response> rentableProduct(int id) async {
    Response response = await dio.patch("/products/rentable/$id");
    return response;
  }

  Future<Response> stopProduct(int id) async {
    Response response = await dio.patch("/products/stop/$id");
    return response;
  }

  Future<List> getProRent(int userIdx, int page, int category) async {
    ApiResponse defaultJson;
    try {
      print("빌려드려요 접속");
      Response res = await dio.get(
        '/user/myactivity',
        queryParameters: {
          'userIdx': userIdx,
          'page': page,
          'category': category,
          'type': 'rent'
        },
      );
      print('빌려드려요 접속 상태 === > ${res.statusCode}');
      Map<String, dynamic> jsonMap = jsonDecode(res.toString());
      List<ProductMyActRent> datas = (jsonMap['data'] as List)
          .map((e) => ProductMyActRent.fromJson(e))
          .toList();
      jsonMap['data'] = datas;
      defaultJson = ApiResponse<List<ProductMyActRent>>.fromJson(jsonMap);
    } on DioError catch (e) {
      print(e.response.statusCode);
      print(e.response.headers);
      print(e.response.request);
      print(e.request);
    }
    return defaultJson.data;
  }

  Future<Response> rentStatusModified(int idx, String token) async {
    try {
      print('빌려드려요 상태 수정');
      print(token);
      dio.options.contentType = "application/x-www-form-urlencoded";
      dio.options.headers['x-access-token'] = token;
      Response res = await dio.patch('/product/status', data: {
        'productIdx': idx,
      });
      print('빌려드려요 상태 수정 상태 ====  ${res.statusCode}');
      return res;
    } on DioError catch (e) {
      print(e.response.statusCode);
      print(e.request);
      print(e.response.data.toString());
    }
  }

  Future<Response> getMainRent(double lati, double longti, int page) async {
    // ApiResponse defaultJson;
    try {
      print("메인페이지 빌려드려요 접속");
      Response res = await dio.get(
        '/product/list',
        queryParameters: {
          'category': 1,
          'page': page,
          'type': 'Rent',
          'search': "",
          "latitude": lati,
          'longitude': longti,
        },
      );
      print('메인 빌려드려요 접속 상태 === > ${res.statusCode}');
      // Map<String, dynamic> jsonMap = jsonDecode(res.toString());
      // defaultJson = ApiResponse<List<MainPageRentWithCounter>>.fromJson(jsonMap);
      return res;
    } on DioError catch (e) {
      print(e.response.statusCode);
      print(e.response.headers);
      print(e.response.request);
      print(e.request);
    }
    // return defaultJson.data;
  }

  Future<Response> getMainWant(double lati, double longti, int page) async {
    // ApiResponse defaultJson;
    try {
      print("메인페이지 빌려주세요 접속");
      Response res = await dio.get(
        '/product/list',
        queryParameters: {
          'category': 1,
          'page': page,
          'type': 'Want',
          'search': "",
          "latitude": lati,
          'longitude': longti,
        },
      );
      print('메인 빌려드려요 접속 상태 === > ${res.statusCode}');
      // Map<String, dynamic> jsonMap = jsonDecode(res.toString());
      // defaultJson = ApiResponse<List<MainPageRentWithCounter>>.fromJson(jsonMap);
      return res;
    } on DioError catch (e) {
      print(e.response.statusCode);
      print(e.response.headers);
      print(e.response.request);
      print(e.request);
    }
    // return defaultJson.data;
  }

  Future<Response> getCategoryProducts(String category, int page, String type,
      double lati, double longti) async {
    try {
      print(category);
      print(page);
      print(type);
      print(lati);
      print(longti);
      print("카테고리 접속");
      Response res = await dio.get(
        '/product/list',
        queryParameters: {
          'category': category,
          'page': page,
          'type': type,
          'search': "",
          'latitude': lati,
          'longitude': longti,
        },
      );
      return res;
    } on DioError catch (e) {
      print("카테고리 접속 에러");
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> productDetail(int productIdx, var lati, var longti) async {
    try {
      print("상품 상세정보 접속");
      Response res = await dio.get(
        '/product/detail',
        queryParameters: {
          'productIdx': productIdx,
          'latitude': lati,
          'longitude': longti,
        },
      );
      return res;
    } on DioError catch (e) {
      print("상품 상세정보 접속 에러");
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> productReview(int productIdx, int page) async {
    try {
      print('물품 리뷰 가져오기 접속');
      Response res = await dio.get(
        '/review/list',
        queryParameters: {
          'productIdx': productIdx,
          'page': page,
        },
      );
      return res;
    } on DioError catch (e) {
      print("물품 리뷰 가져오기 실패");
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> productAddRent(
    String userPh,
    int userIdx,
    int categoryIdx,
    String title,
    String description,
    int price,
    String startDate,
    String endDate,
    String address,
    String addressDetail,
    num la,
    num lo,
    String token,
    List<dynamic> productImg,
  ) async {
    try {
      print(title);
      print("상품 빌려주기 등록");
      dio.options.contentType = "multipart/form-data";
      dio.options.headers['x-access-token'] = token;
      FormData formData = FormData.fromMap({
        "username": userPh,
        'userIdx': userIdx,
        'categoryIdx': categoryIdx,
        'title': title,
        'description': description,
        'price': price,
        'minPrice': 0,
        'maxPrice': 0,
        "count": 1,
        "type": "RENT",
        "startDate": startDate,
        "endDate": endDate,
        "address": address,
        "address_detail": addressDetail,
        "latitude": la,
        "longitude": lo,
        "productImg": productImg,
      });
      Response res = await dio.post(
        '/product/add',
        data: formData,
      );
      return res;
    } on DioError catch (e) {
      print("상품 등록 에러 빌려주기");
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> productAddWant(
      String userPh,
      int userIdx,
      int categoryIdx,
      String title,
      String description,
      int minPrice,
      int maxPrice,
      String startDate,
      String endDate,
      String address,
      String addressDetail,
      num la,
      num lo,
      String token,
      List<dynamic> productImg,
      ) async {
    try {
      print("$la $lo");
      print("상품 빌려주기 등록");
      dio.options.contentType = "multipart/form-data";
      dio.options.headers['x-access-token'] = token;
      FormData formData = FormData.fromMap({
        "username": userPh,
        'userIdx': userIdx,
        'categoryIdx': categoryIdx,
        'title': title,
        'description': description,
        'price': 0,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
        "count": 1,
        "type": "WANT",
        "startDate": startDate,
        "endDate": endDate,
        "address": address,
        "address_detail": addressDetail,
        "latitude": la,
        "longitude": lo,
        "productImg": productImg,
      });
      Response res = await dio.post(
        '/product/add',
        data: formData,
      );
      return res;
    } on DioError catch (e) {
      print("상품 등록 에러 빌려주기");
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> productAddpri(
      String userPh,
      int userIdx,
      int categoryIdx,
      int productIdx,
      String title,
      String description,
      int Price,
      String startDate,
      String endDate,
      String address,
      String addressDetail,
      num la,
      num lo,
      String token,
      List<dynamic> productImg,
      ) async {
    try {
      print("상품 빌려주세요 대여등록");
      dio.options.contentType = "multipart/form-data";
      dio.options.headers['x-access-token'] = token;
      FormData formData = FormData.fromMap({
        "username": userPh,
        'userIdx': userIdx,
        'categoryIdx': categoryIdx,
        'productIdx' : productIdx,
        'title': title,
        'description': description,
        'price': Price,
        "address": address,
        "address_detail": addressDetail,
        "latitude": la,
        "longitude": lo,
        "productImg": productImg,
      });
      Response res = await dio.post(
        '/product/add/private',
        data: formData,
      );
      return res;
    } on DioError catch (e) {
      print("상품 등록 에러 빌려주기");
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> sendReview(int userIdx, int productIdx, String description,
      int grade, String token) async {
    try {
      print(userIdx);
      print(productIdx);
      print(description);
      print(grade);
      print(token);
      print("리뷰 보내기 접속");
      dio.options.contentType = "application/x-www-form-urlencoded";
      dio.options.headers['x-access-token'] = token;
      Response res = await dio.post('/review/write', data: {
        'userIdx': userIdx,
        'productIdx': productIdx,
        'subject': "리뷰등록",
        "content": description,
        "grade": grade,
      });
      return res;
    } on DioError catch (e) {
      print("리뷰 보내기 접속 에러");
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> getGeo(num la, num long) async {
    print("주소값 불러오기");
    print(la);
    print(long);
    try {
      Response res = await dio.get('/geo', queryParameters: {
        'latitude': la,
        'longitude': long,
      });
      return res;
    } on DioError catch (e) {
      print('위치 조회 에러');
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> delProduct(int productIdx, String token) async {
    print("$productIdx 물품 삭제 접속");
    print(token);
    try{
      dio.options.contentType = "application/x-www-form-urlencoded";
      dio.options.headers['x-access-token'] = token;
      Response res = await dio.delete(
        '/product/delete',
        data: {
          'productIdx' : productIdx,
        }
      );
      return res;
    }on DioError catch(e){
      print("물품삭제 접속 에러");
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> privateList(int productIdx, num la, num lo, int page, String token) async{
    print("대여 제공 리스트 접속");
    try{
      dio.options.headers['x-access-token'] = token;
      Response res = await dio.get(
        '/product/list/private',
        queryParameters: {
          'productIdx': productIdx,
          'latitude' : la,
          'longitude' : lo,
          'page' : page,
        }
      );
      return res;
    }on DioError catch(e){
      print("대여 제공 리스트 접속 에러");
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> chatList(int userIdx, int page, String token) async {
    print('채팅내역 접속');
    try{
      dio.options.headers['x-access-token'] = token;
      Response res = await dio.get(
        '/history/chat',
        queryParameters: {
          'userIdx' : userIdx,
          'page' : page,
        }
      );
      return res;
    }on DioError catch(e) {
      print(e);
    }
  }

  Future<Response> rentHistory(int userIdx, int page, String token) async {
    print('대여 물품 접속');
    try{
      dio.options.headers['x-access-token'] = token;
      Response res = await dio.get(
        '/history',
        queryParameters: {
          'userIdx' : userIdx,
          'page' : page,
        }
      );
      return res;
    }on DioError catch(e){
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> productInit(int senderIdx, int receiverIdx, int productIdx, String token) async {
    print("대여 문의 하기 접속");
    try{
      dio.options.headers['x-access-token'] = token;
      Response res = await dio.post(
        '/product/init',
        data: {
          'sender' : senderIdx,
          'receiver' : receiverIdx,
          'productIdx' : productIdx,
        }
      );
      return res;
    }on DioError catch(e) {
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }
}
