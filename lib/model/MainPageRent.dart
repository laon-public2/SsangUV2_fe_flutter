class MainPageRent {
  int id;
  String title = "";
  int price;
  int category;
  String name;
  num distance;
  List<ProductFile> productFiles;
  // String productFiles;

  MainPageRent.fromJson(Map<String, dynamic> json)
      : id = json["idx"],
        name = json['name'],
        title = json["title"],
        price = json["price"],
        distance = json['distance'],
        category = json['category_idx'],
        productFiles = json['image'] != null
            ? (json['image'] as List)
                .map((e) => ProductFile.fromJson(e))
                .toList()
            : List<ProductFile>.empty();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'title': title,
    'price': price,
    'distance': distance,
    'category' : category,
    'image': productFiles.isEmpty ? null : productFiles,
    // 'productFiles': productFiles
  };


}

class ProductFile {
  int id;
  String path;

  ProductFile.fromJson(Map<String, dynamic> json)
      : id = json["file_idx"],
        path = json["file"];
}
