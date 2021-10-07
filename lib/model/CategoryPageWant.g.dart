// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CategoryPageWant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryPageWant _$CategoryPageWantFromJson(Map<String, dynamic> json) {
  return CategoryPageWant(
    json['idx'] as int,
    json['title'] as String,
    json['min_price'] as int,
    json['max_price'] as int,
    json['category_idx'] as int?,
    json['start_date'] as String,
    json['end_date'] as String,
    json['name'] as String,
    json['distance'] as num,
    (json['image'] as List<dynamic>)
        .map((e) => ProductFile.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$CategoryPageWantToJson(CategoryPageWant instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'title': instance.title,
      'min_price': instance.min_price,
      'max_price': instance.max_price,
      'category_idx': instance.category_idx,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'name': instance.name,
      'distance': instance.distance,
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
