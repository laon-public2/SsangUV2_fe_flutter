// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatListModel _$ChatListModelFromJson(Map<String, dynamic> json) {
  return ChatListModel(
    json['senderIdx'] as int,
    json['senderNumber'] as String,
    json['senderName'] as String,
    json['senderType'] as String,
    json['senderBusinessNum'] as String,
    json['senderAddress'] as String,
    json['senderAddressDetail'] as String,
    json['senderLa'] as num,
    json['senderLo'] as num,
    json['senderFcmToken'] as String,
    json['receiverIdx'] as int,
    json['receiverNumber'] as String,
    json['receiverName'] as String,
    json['receiverType'] as String,
    json['receiverBusinessNum'] as String,
    json['receiverAddress'] as String,
    json['receiverAddressDetail'] as String,
    json['receiverLa'] as num,
    json['receiverLo'] as num,
    json['receiverFcmToken'] as String,
    json['productIdx'] as int,
    json['productTitle'] as String,
    json['productDescription'] as String,
    json['productPrice'] as int,
    json['productMinPrice'] as int,
    json['productMaxPrice'] as int,
    json['productType'] as String,
    json['productStatus'] as String,
    json['status'] as String,
    json['type'] as String,
    json['uuid'] as String,
    json['isNew'] as int,
    json['startDate'] as String,
    json['endDate'] as String,
    json['categoryNum'] as int,
    (json['productFiles'] as List<dynamic>)
        .map((e) => ProductFile.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ChatListModelToJson(ChatListModel instance) =>
    <String, dynamic>{
      'senderIdx': instance.senderIdx,
      'senderNumber': instance.senderNumber,
      'senderName': instance.senderName,
      'senderType': instance.senderType,
      'senderBusinessNum': instance.senderBusinessNum,
      'senderAddress': instance.senderAddress,
      'senderAddressDetail': instance.senderAddressDetail,
      'senderLa': instance.senderLa,
      'senderLo': instance.senderLo,
      'senderFcmToken': instance.senderFcmToken,
      'receiverIdx': instance.receiverIdx,
      'receiverNumber': instance.receiverNumber,
      'receiverName': instance.receiverName,
      'receiverType': instance.receiverType,
      'receiverBusinessNum': instance.receiverBusinessNum,
      'receiverAddress': instance.receiverAddress,
      'receiverAddressDetail': instance.receiverAddressDetail,
      'receiverLa': instance.receiverLa,
      'receiverLo': instance.receiverLo,
      'receiverFcmToken': instance.receiverFcmToken,
      'productIdx': instance.productIdx,
      'productTitle': instance.productTitle,
      'productDescription': instance.productDescription,
      'productPrice': instance.productPrice,
      'productMinPrice': instance.productMinPrice,
      'productMaxPrice': instance.productMaxPrice,
      'productType': instance.productType,
      'productStatus': instance.productStatus,
      'status': instance.status,
      'type': instance.type,
      'uuid': instance.uuid,
      'isNew': instance.isNew,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'categoryNum': instance.categoryNum,
      'productFiles': instance.productFiles,
    };

ProductFile _$ProductFileFromJson(Map<String, dynamic> json) {
  return ProductFile(
    json['id'] as int,
    json['path'] as String,
  );
}

Map<String, dynamic> _$ProductFileToJson(ProductFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
    };
