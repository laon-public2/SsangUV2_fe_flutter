import 'package:share_product_v2/model/product.dart';
import 'package:share_product_v2/models/member.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contract.g.dart';

@JsonSerializable()
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

  factory ContractModel.fromJson(Map<String, dynamic> json) => _$ContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractModelToJson(this);

  // ContractModel.fromJson(Map<String, dynamic> json)
  //     : id = json["id"],
  //       createdDate = json["createdDate"],
  //       updatedDate = json["updatedDate"],
  //       borrowedDate = json["borrowedDate"],
  //       returnDate = json["returnDate"],
  //       status = json['status'],
  //       borrower = Member.fromJson(json["borrower"]),
  //       product = Product.fromJson(json["product"]);
  //
  // ContractModel(
  //     {this.id,
  //     this.createdDate,
  //     this.updatedDate,
  //     this.borrower,
  //     this.product,
  //     this.status,
  //     this.borrowedDate,
  //     this.returnDate});
}
