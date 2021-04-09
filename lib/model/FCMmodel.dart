class FcmModel {
  int productIdx;
  String uuid;
  int categoryIdx;
  String productOwner;
  int price;
  String status;
  String receiverIdx;

  FcmModel.fromJson(Map<String, dynamic> json)
      : productIdx = json['productIdx'],
        uuid = json['uuid'],
        categoryIdx = json['categoryIdx'],
        productOwner = json['productOwner'],
        price = json['price'],
        status = json['status'],
        receiverIdx = json['receiverIdx'];

}