class UserNoticeModel {
  int userIdx;
  num targetUserIdx;
  int productIdx;
  String status;
  String createAt;
  String receiver;
  String title;
  List<ProductFile> productFiles;
  // UserNoticeModel(this.userIdx, this.targetUserIdx, this.productIdx, this.status, this.createAt, this.receiver);

  UserNoticeModel.fromJson(Map<String, dynamic> json)
      : userIdx = json['user_idx'],
        targetUserIdx = json['target_user_idx'],
        productIdx = json['product_idx'],
        status = json['status'],
        title = json['title'],
        createAt = json['created_at'],
        receiver = json['receiver_name'],
        productFiles = json['image'] != null
        ? (json['image'] as List)
            .map((e) => ProductFile.fromJson(e))
            .toList()
            : List<ProductFile>.empty();
}

class ProductFile {
  int id;
  String path;

  ProductFile.fromJson(Map<String, dynamic> json)
      : id = json["file_idx"],
        path = json["file"];
}