import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:share_product_v2/model/product.dart';
import 'package:share_product_v2/models/default.dart';
import 'package:share_product_v2/utils/APIUtil.dart';
import 'package:http_parser/http_parser.dart';

class ContractService {
  Dio dio = ApiUtils.instance.dio;
  Dio chatDio = ChatUtils.instance.dio;

  Future<ApiResponse> contract(int productIdx) async {
    Response response =
        await dio.post("/contracts", data: {"product": productIdx});

    ApiResponse apiResponse = ApiResponse<String>.fromJson(response.data);

    return apiResponse;
  }

  Future<Response> getContracts(int page) async {
    Response response = await dio.get("/contracts/chat", queryParameters: {
      "page": page,
    });

    return response;
  }

  Future<Response> getChatHistory(String uuid, int page) async {
    print("uuid : $uuid");
    print("page : $page");
    try {
      Response response = await chatDio.get(
        "/chat/list/$uuid",
        queryParameters: {
          "page": page,
        },
      );
      return response;
    } on DioError catch (e) {
      print("챗 기록 접속 에러");
      print(e.response.statusCode);
      print(e.response.data.toString());
    }
  }

  Future<Response> contractUUID(String uuid) async {
    Response response = await dio.get("/contracts/${uuid}");

    return response;
  }

  Future<Response> contractWrite(String uuid, Map<String, dynamic> data) async {
    Response response = await dio.put("/contracts/${uuid}", data: data);
    return response;
  }

  Future<Response> contractApproval(String uuid) async {
    Response response = await dio.patch("/contracts/${uuid}");
    return response;
  }

  //대여 해준 내역
  Future<Response> contractDo() async {
    Response response = await dio.get("/contracts/do");
    return response;
  }

  //대여 받은 내역
  Future<Response> contractReceive() async {
    Response response = await dio.get("/contracts/receive");
    return response;
  }

  Future<http.StreamedResponse> sendImgFile(List<Asset> imgFiles, String uuid, String sender) async {
    var url = Uri.parse("http://115.91.73.66:11111/chat/image");
    var imgInfo = jsonEncode({
      "orderId": uuid,
      "sender": sender,
      "content": "SSangU_Chat_Image",
      "type": "IMAGE",
    });
    var request = http.MultipartRequest('POST', url);

    request.files.add(
      http.MultipartFile.fromBytes(
        'chat',
        utf8.encode(imgInfo),
        contentType: MediaType(
          'application',
          'json',
          {'charset': 'utf-8'},
        ),
      ),
    );

    for(var file in imgFiles) {
      print("이미지 갯수만큼");
      ByteData byteData = await file.getByteData(quality: 30); //getByteData에 이미지 품질을 넣을 수 있음 (주의! 폰 성능이 매우 필요로 함. 똥폰은 앱이 꺼질 수 있으니 주의해야 함.)
      List<int> imageData = byteData.buffer.asUint8List();
      request.files.add(
        http.MultipartFile.fromBytes(
          'img',
          imageData,
          filename: file.name,
        ),
      );
    }
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print("챗팅 이미지 업로드 에러");
      print(response.statusCode);
      print(response.reasonPhrase.toString());
    }
    // return response.reasonPhrase;
  }
}
