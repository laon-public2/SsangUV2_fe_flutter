import 'package:json_annotation/json_annotation.dart';

part 'productMyActRent.g.dart';

@JsonSerializable()
class ProductMyActRent {
  int idx;
  String title = "";
  int price;
  String date;
  String start_date;
  String end_date;
  String name;
  int min_price;
  int max_price;
  String type;
  String status;
  String address;
  String address_detail;
  List<ProductFile> image;

  ProductMyActRent(
      this.idx,
      this.title,
      this.price,
      this.date,
      this.start_date,
      this.end_date,
      this.name,
      this.min_price,
      this.max_price,
      this.type,
      this.status,
      this.address,
      this.address_detail,
      this.image);
// String productFiles;

  factory ProductMyActRent.fromJson(Map<String, dynamic> json) => _$ProductMyActRentFromJson(json);

  Map<String, dynamic> toJson() => _$ProductMyActRentToJson(this);


}

@JsonSerializable()
class ProductFile {
  int file_idx;
  String file;

  ProductFile(this.file_idx, this.file);

  factory ProductFile.fromJson(Map<String, dynamic> json) => _$ProductFileFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFileToJson(this);

//
  // ProductFile.fromJson(Map<String, dynamic> json)
  //     : id = json["file_idx"],
  //       path = json["file"];
}
