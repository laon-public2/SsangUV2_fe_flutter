import 'package:json_annotation/json_annotation.dart';

part 'productMyActRent.g.dart';

@JsonSerializable()
class ProductMyActRent {
  int id;
  String title = "";
  int price;
  String date;
  String startDate;
  String endDate;
  String name;
  int minPrice;
  int maxPrice;
  String type;
  String status;
  String address;
  String addressDetail;
  List<ProductFile> productFiles;

  ProductMyActRent(
      this.id,
      this.title,
      this.price,
      this.date,
      this.startDate,
      this.endDate,
      this.name,
      this.minPrice,
      this.maxPrice,
      this.type,
      this.status,
      this.address,
      this.addressDetail,
      this.productFiles);
// String productFiles;

  factory ProductMyActRent.fromJson(Map<String, dynamic> json) => _$ProductMyActRentFromJson(json);

  Map<String, dynamic> toJson() => _$ProductMyActRentToJson(this);


}

@JsonSerializable()
class ProductFile {
  int id;
  String path;

  ProductFile(this.id, this.path);

  factory ProductFile.fromJson(Map<String, dynamic> json) => _$ProductFileFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFileToJson(this);

//
  // ProductFile.fromJson(Map<String, dynamic> json)
  //     : id = json["file_idx"],
  //       path = json["file"];
}
