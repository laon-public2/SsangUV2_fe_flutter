import 'package:json_annotation/json_annotation.dart';

part 'chatListModel.g.dart';

@JsonSerializable()

class ChatListModel {
  int senderIdx;
  String senderNumber;
  String senderName;
  String senderType;
  String senderBusinessNum;
  String senderAddress;
  String senderAddressDetail;
  num senderLa;
  num senderLo;
  String senderFcmToken;
  int receiverIdx;
  String receiverNumber;
  String receiverName;
  String receiverType;
  String receiverBusinessNum;
  String receiverAddress;
  String receiverAddressDetail;
  num receiverLa;
  num receiverLo;
  String receiverFcmToken;
  int productIdx;
  String productTitle;
  String productDescription;
  int productPrice;
  int productMinPrice;
  int productMaxPrice;
  String productType;
  String productStatus;
  String status;
  String type;
  String uuid;
  int isNew;
  String startDate;
  String endDate;
  int categoryNum;
  List<ProductFile> productFiles;

  ChatListModel(
      this.senderIdx,
      this.senderNumber,
      this.senderName,
      this.senderType,
      this.senderBusinessNum,
      this.senderAddress,
      this.senderAddressDetail,
      this.senderLa,
      this.senderLo,
      this.senderFcmToken,
      this.receiverIdx,
      this.receiverNumber,
      this.receiverName,
      this.receiverType,
      this.receiverBusinessNum,
      this.receiverAddress,
      this.receiverAddressDetail,
      this.receiverLa,
      this.receiverLo,
      this.receiverFcmToken,
      this.productIdx,
      this.productTitle,
      this.productDescription,
      this.productPrice,
      this.productMinPrice,
      this.productMaxPrice,
      this.productType,
      this.productStatus,
      this.status,
      this.type,
      this.uuid,
      this.isNew,
      this.startDate,
      this.endDate,
      this.categoryNum,
      this.productFiles);

  factory ChatListModel.fromJson(Map<String, dynamic> json) => _$ChatListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatListModelToJson(this);
}

@JsonSerializable()
class ProductFile {
  int id;
  String path;

  ProductFile(this.id, this.path);

  factory ProductFile.fromJson(Map<String, dynamic> json) => _$ProductFileFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFileToJson(this);

// ProductFile.fromJson(Map<String, dynamic> json)
  //     : id = json["file_idx"],
  //       path = json["file"];
}
