import 'package:share_product_v2/models/member.dart';

import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()

class Product {
  int id;
  String title = "";
  String description = "";
  int price = 0;
  int dateCount = 0;
  String createdDate = "";
  String updatedDate = "";
  Member member;
  Category category;
  List<ProductFile> productFiles;
  String status;

  Product(
      this.id,
      this.title,
      this.description,
      this.price,
      this.dateCount,
      this.createdDate,
      this.updatedDate,
      this.member,
      this.category,
      this.productFiles,
      this.status);

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

}

@JsonSerializable()
class Category {
  int id;
  String name;


  Category(this.id, this.name);

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class ProductFile {
  int id;
  String path;

  ProductFile(this.id, this.path);

  factory ProductFile.fromJson(Map<String, dynamic> json) => _$ProductFileFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFileToJson(this);


}
