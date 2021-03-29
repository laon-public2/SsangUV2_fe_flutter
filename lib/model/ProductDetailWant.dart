class productDetailWant {
  int id;
  String title = "";
  int receiverIdx;
  int price;
  int minPrice;
  int maxPrice;
  int category;
  String description;
  String type;
  String startDate;
  String endDate;
  String address;
  String addressDetail;
  String name;
  bool review;
  num lati;
  num longti;
  num distance;
  List<ProductFile> productFiles;
  // String productFiles;

  productDetailWant.fromJson(Map<String, dynamic> json)
      : id = json["idx"],
        type = json["type"],
        receiverIdx = json['receiver_idx'],
        name = json['name'],
        title = json["title"],
        price = json['price'],
        minPrice = json["min_price"],
        maxPrice = json["max_price"],
        startDate = json['start_date'],
        endDate = json['end_date'],
        distance = json['distance'],
        address = json['user_address'],
        addressDetail = json['user_address_detail'],
        category = json['category_idx'],
        description = json['description'],
        review = json['review_possible'],
        lati = json['location']['y'],
        longti = json['location']['x'],
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
