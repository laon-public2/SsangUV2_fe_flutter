import 'package:share_product_v2/model/product.dart';
import 'package:share_product_v2/models/member.dart';

class SpecialProduct {
  int id;
  String title;
  String description;
  String createdDate;
  String updatedDate;
  List<SpecialProductItems> specialProductItems;

  SpecialProduct.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        description = json["description"],
        createdDate = json["createdDate"],
        updatedDate = json["updatedDate"],
        specialProductItems = json['specialProductItems'] != null
            ? (json['specialProductItems'] as List)
                .map((e) => SpecialProductItems.fromJson(e))
                .toList()
            : List<SpecialProductItems>.empty();
}

class SpecialProductItems {
  int id;
  Product product;
  SpecialProductItems.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        product = Product.fromJson(json['product']);
}
