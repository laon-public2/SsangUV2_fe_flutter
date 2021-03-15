class MainPageWant {
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
  // String productFiles;

  MainPageWant.fromJson(Map<String, dynamic> json)
      : id = json["idx"],
        name = json['name'],
        title = json["title"],
        minPrice = json["min_price"],
        maxPrice = json["max_price"],
        startDate = json['start_date'],
        endDate = json['end_date'],
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
    'minPrice': minPrice,
    'maxPrice' : maxPrice,
    'startDate' : startDate,
    "endDate" : endDate,
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
