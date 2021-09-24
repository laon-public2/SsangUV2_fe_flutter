// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productMyActRent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductMyActRent _$ProductMyActRentFromJson(Map<String, dynamic> json) {
  return ProductMyActRent(
    json['id'] as int,
    json['title'] as String,
    json['price'] as int,
    json['date'] as String,
    json['startDate'] as String,
    json['endDate'] as String,
    json['name'] as String,
    json['minPrice'] as int,
    json['maxPrice'] as int,
    json['type'] as String,
    json['status'] as String,
    json['address'] as String,
    json['addressDetail'] as String,
    (json['productFiles'] as List<dynamic>)
        .map((e) => ProductFile.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ProductMyActRentToJson(ProductMyActRent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'date': instance.date,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'name': instance.name,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'type': instance.type,
      'status': instance.status,
      'address': instance.address,
      'addressDetail': instance.addressDetail,
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
