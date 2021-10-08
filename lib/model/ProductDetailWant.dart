
import 'package:json_annotation/json_annotation.dart';

part 'ProductDetailWant.g.dart';

@JsonSerializable()

class productDetailWant {
  int idx;
  String title = "";
  int? receiver_idx;
  int price;
  int min_price;
  int max_price;
  int? category_idx;
  String description;
  String type;
  String start_date;
  String end_date;
  String address;
  String address_detail;
  String name;
  bool? review_possible;
  Location location;
  num? distance;
  String fcm_token;
  List<ProductFile> image;
  // String productFiles;

  productDetailWant(
      this.idx,
      this.title,
      this.receiver_idx,
      this.price,
      this.min_price,
      this.max_price,
      this.category_idx,
      this.description,
      this.type,
      this.start_date,
      this.end_date,
      this.address,
      this.address_detail,
      this.name,
      this.review_possible,
      this.location,
      this.distance,
      this.fcm_token,
      this.image);



  factory productDetailWant.fromJson(Map<String, dynamic> json) => _$productDetailWantFromJson(json);

  Map<String, dynamic> toJson() => _$productDetailWantToJson(this);

  // productDetailWant.fromJson(Map<String, dynamic> json)
  //     : id = json["idx"],
  //       type = json["type"],
  //       receiverIdx = json['receiver_idx'],
  //       name = json['name'],
  //       title = json["title"],
  //       price = json['price'],
  //       minPrice = json["min_price"],
  //       maxPrice = json["max_price"],
  //       startDate = json['start_date'],
  //       endDate = json['end_date'],
  //       distance = json['distance'],
  //       address = json['address'],
  //       addressDetail = json['address_detail'],
  //       category = json['category_idx'],
  //       description = json['description'],
  //       review = json['review_possible'],
  //       lati = json['location']['y'],
  //       longti = json['location']['x'],
  //       fcmToken = json['fcm_token'] == null ? "none" : json['fcm_token'],
  //       productFiles = json['image'] != null
  //           ? (json['image'] as List)
  //           .map((e) => ProductFile.fromJson(e))
  //           .toList()
  //           : List<ProductFile>.empty();
  //
  // Map<String, dynamic> toJson() => {
  //   'id': id,
  //   'name': name,
  //   'title': title,
  //   'minPrice': minPrice,
  //   'maxPrice' : maxPrice,
  //   'startDate' : startDate,
  //   "endDate" : endDate,
  //   'distance': distance,
  //   'category' : category,
  //   'image': productFiles.isEmpty ? null : productFiles,
  //   // 'productFiles': productFiles
  // };


}

@JsonSerializable()
class ProductFile {
  int file_idx;
  String file;

  ProductFile(this.file_idx, this.file);

  factory ProductFile.fromJson(Map<String, dynamic> json) => _$ProductFileFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFileToJson(this);


  // ProductFile.fromJson(Map<String, dynamic> json)
  //     : id = json["file_idx"],
  //       path = json["file"];
}

@JsonSerializable()
class Location {
  num y;
  num x;

  Location(this.y, this.x);

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);


// ProductFile.fromJson(Map<String, dynamic> json)
//     : id = json["file_idx"],
//       path = json["file"];
}

