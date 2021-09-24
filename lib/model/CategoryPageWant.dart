import 'package:json_annotation/json_annotation.dart';

part 'CategoryPageWant.g.dart';

@JsonSerializable()
class CategoryPageWant {
  int id;
  String title = "";
  int minPrice;
  int maxPrice;
  int category;
  String startDate;
  String endDate;
  String name;
  num distance;
  List<ProductFile> productFiles;

  CategoryPageWant(
      this.id,
      this.title,
      this.minPrice,
      this.maxPrice,
      this.category,
      this.startDate,
      this.endDate,
      this.name,
      this.distance,
      this.productFiles);
// String productFiles;

  factory CategoryPageWant.fromJson(Map<String, dynamic> json) => _$CategoryPageWantFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryPageWantToJson(this);

  // CategoryPageWant.fromJson(Map<String, dynamic> json)
  //     : id = json["idx"],
  //       name = json['name'],
  //       title = json["title"],
  //       minPrice = json["min_price"],
  //       maxPrice = json["max_price"],
  //       startDate = json['start_date'],
  //       endDate = json['end_date'],
  //       distance = json['distance'],
  //       category = json['category_idx'],
  //       productFiles = json['image'] != null
  //           ? (json['image'] as List)
  //               .map((e) => ProductFile.fromJson(e))
  //               .toList()
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
  int id;
  String path;

  ProductFile(this.id, this.path);
  factory ProductFile.fromJson(Map<String, dynamic> json) => _$ProductFileFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFileToJson(this);

  // ProductFile.fromJson(Map<String, dynamic> json)
  //     : id = json["file_idx"],
  //       path = json["file"];
}
