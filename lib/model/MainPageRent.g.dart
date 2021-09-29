// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MainPageRent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainPageRent _$MainPageRentFromJson(Map<String, dynamic> json) {
  return MainPageRent(
    json['idx'] as int,
    json['title'] as String,
    json['price'] as int,
    json['category_idx'] as int?,
    json['name'] as String,
    json['distance'] as num,
    json['receiver_idx'] as int?,
    (json['image'] as List<dynamic>)
        .map((e) => ProductFile.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$MainPageRentToJson(MainPageRent instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'title': instance.title,
      'price': instance.price,
      'category_idx': instance.category_idx,
      'name': instance.name,
      'distance': instance.distance,
      'receiver_idx': instance.receiver_idx,
      'image': instance.image,
    };

ProductFile _$ProductFileFromJson(Map<String, dynamic> json) {
  return ProductFile(
    json['file_idx'] as int?,
    json['file'] as String,
  );
}

Map<String, dynamic> _$ProductFileToJson(ProductFile instance) =>
    <String, dynamic>{
      'file_idx': instance.file_idx,
      'file': instance.file,
    };
