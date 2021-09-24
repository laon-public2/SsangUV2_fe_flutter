import 'package:json_annotation/json_annotation.dart';

part 'productMyActWant.g.dart';

@JsonSerializable()
class Product {
  int id;
  String title = "";
  int price = 0;
  int dateCount = 0;
  Category category;
  List<ProductFile> productFiles;
  String status;

  Product(this.id, this.title, this.price, this.dateCount, this.category,
      this.productFiles, this.status);

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

//

// Product.fromJson(Map<String, dynamic> json)
  //     : id = json["id"],
  //       title = json["title"],
  //       price = json["price"],
  //       dateCount = json["dateCount"],
  //       status = json['status'],
  //       category = json["category"] != null
  //           ? Category.fromJson(json["category"])
  //           : Category(),
  //       productFiles = json['productFiles'] != null
  //           ? (json['productFiles'] as List)
  //               .map((e) => ProductFile.fromJson(e))
  //               .toList()
  //           : List<ProductFile>.empty();
  //
  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'title': title,
  //       'category': category.name,
  //       'productFiles': productFiles.isEmpty ? null : productFiles[0].path,
  //     };
}

@JsonSerializable()
class Category {
  int id;
  String name;


  Category(this.id, this.name);

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

//

  // Category.fromJson(Map<String, dynamic> json)
  //     : id = json["id"],
  //       name = json["name"];
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
  //     : id = json["id"],
  //       path = json["path"];
}
