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
  // String productFiles;

  ProductMyActRent.fromJson(Map<String, dynamic> json)
      : id = json["idx"],
        name = json['name'],
        title = json["title"],
        startDate = json['start_date'],
        endDate = json['end_date'],
        minPrice = json['min_price'],
        maxPrice = json['max_price'],
        price = json["price"],
        status = json['status'],
        type = json['type'],
        productFiles = json['image'] != null
            ? (json['image'] as List)
                .map((e) => ProductFile.fromJson(e))
                .toList()
            : List<ProductFile>.empty();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'status': status,
        'title': title,
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
