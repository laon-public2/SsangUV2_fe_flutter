import 'package:share_product_v2/model/product.dart';
import 'package:share_product_v2/models/member.dart';

class ContractModel {
  String id;
  String createdDate = "";
  String updatedDate = "";
  Member borrower;
  Product product;
  String status = "";
  String borrowedDate = "";
  String returnDate = "";

  ContractModel(this.id, this.createdDate, this.updatedDate, this.borrower,
      this.product, this.status, this.borrowedDate, this.returnDate);

  ContractModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        createdDate = json["createdDate"],
        updatedDate = json["updatedDate"],
        borrowedDate = json["borrowedDate"],
        returnDate = json["returnDate"],
        status = json['status'],
        borrower = Member.fromJson(json["borrower"]),
        product = Product.fromJson(json["product"]);

}
