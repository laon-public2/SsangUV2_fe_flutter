import 'package:json_annotation/json_annotation.dart';

part 'MainPageRent.g.dart';

@JsonSerializable()

class MainPageRent {
  int idx;
  String title = "";
  int price;
  int? category_idx;
  String name;
  num distance;
  int? receiver_idx;
  List<ProductFile> image;

  MainPageRent(
      this.idx,
      this.title,
      this.price,
      this.category_idx,
      this.name,
      this.distance,
      this.receiver_idx,
      this.image); // String productFiles;

  factory MainPageRent.fromJson(Map<String, dynamic> json) => _$MainPageRentFromJson(json);

  Map<String, dynamic> toJson() => _$MainPageRentToJson(this);

  // MainPageRent.fromJson(Map<String, dynamic> json)
  //     : id = json["idx"],
  //       name = json['name'],
  //       title = json["title"],
  //       price = json["price"],
  //       distance = json['distance'],
  //       receiverIdx = json['receiver_idx'],
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
  //   // 'receiverIdx' : receiverIdx,
  //   'category' : category,
  //   'image': productFiles.isEmpty ? null : productFiles,
  //   // 'productFiles': productFiles
  // };


}

@JsonSerializable()
class ProductFile {
  int? file_idx;
  String file;

  ProductFile(this.file_idx, this.file);

  factory ProductFile.fromJson(Map<String, dynamic> json) => _$ProductFileFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFileToJson(this);

  // ProductFile.fromJson(Map<String, dynamic> json)
  //     : id = json["file_idx"],
  //       path = json["file"];
}
