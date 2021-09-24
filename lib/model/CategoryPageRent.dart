import 'package:json_annotation/json_annotation.dart';

part 'CategoryPageRent.g.dart';

@JsonSerializable()
class CategoryPageRent {
  int id;
  String title = "";
  int price;
  int category;
  String name;
  num distance;
  List<ProductFile> productFiles;

  CategoryPageRent(this.id, this.title, this.price, this.category, this.name,
      this.distance, this.productFiles); // String productFiles;

  factory CategoryPageRent.fromJson(Map<String, dynamic> json) => _$CategoryPageRentFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryPageRentToJson(this);

  // CategoryPageRent.fromJson(Map<String, dynamic> json)
  //     : id = json["idx"],
  //       name = json['name'],
  //       title = json["title"],
  //       price = json["price"],
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
  //   'price': price,
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
