// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractModel _$ContractModelFromJson(Map<String, dynamic> json) {
  return ContractModel(
    json['id'] as String,
    json['createdDate'] as String,
    json['updatedDate'] as String,
    Member.fromJson(json['borrower'] as Map<String, dynamic>),
    Product.fromJson(json['product'] as Map<String, dynamic>),
    json['status'] as String,
    json['borrowedDate'] as String,
    json['returnDate'] as String,
  );
}

Map<String, dynamic> _$ContractModelToJson(ContractModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdDate': instance.createdDate,
      'updatedDate': instance.updatedDate,
      'borrower': instance.borrower,
      'product': instance.product,
      'status': instance.status,
      'borrowedDate': instance.borrowedDate,
      'returnDate': instance.returnDate,
    };
