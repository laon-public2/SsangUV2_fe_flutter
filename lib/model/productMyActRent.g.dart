// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productMyActRent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductMyActRent _$ProductMyActRentFromJson(Map<String, dynamic> json) {
  return ProductMyActRent(
    json['idx'] as int,
    json['title'] as String,
    json['price'] as int,
    json['date'] as String,
    json['start_date'] as String,
    json['end_date'] as String,
    json['name'] as String,
    json['min_price'] as int,
    json['max_price'] as int,
    json['type'] as String,
    json['status'] as String,
    json['address'] as String,
    json['address_detail'] as String,
    (json['image'] as List<dynamic>)
        .map((e) => ProductFile.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ProductMyActRentToJson(ProductMyActRent instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'title': instance.title,
      'price': instance.price,
      'date': instance.date,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'name': instance.name,
      'min_price': instance.min_price,
      'max_price': instance.max_price,
      'type': instance.type,
      'status': instance.status,
      'address': instance.address,
      'address_detail': instance.address_detail,
      'image': instance.image,
    };

ProductFile _$ProductFileFromJson(Map<String, dynamic> json) {
  return ProductFile(
    json['file_idx'] as int,
    json['file'] as String,
  );
}

Map<String, dynamic> _$ProductFileToJson(ProductFile instance) =>
    <String, dynamic>{
      'file_idx': instance.file_idx,
      'file': instance.file,
    };
