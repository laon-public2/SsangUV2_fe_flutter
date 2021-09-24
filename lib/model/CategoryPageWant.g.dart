// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CategoryPageWant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryPageWant _$CategoryPageWantFromJson(Map<String, dynamic> json) {
  return CategoryPageWant(
    json['id'] as int,
    json['title'] as String,
    json['minPrice'] as int,
    json['maxPrice'] as int,
    json['category'] as int,
    json['startDate'] as String,
    json['endDate'] as String,
    json['name'] as String,
    json['distance'] as num,
    (json['productFiles'] as List<dynamic>)
        .map((e) => ProductFile.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$CategoryPageWantToJson(CategoryPageWant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'category': instance.category,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'name': instance.name,
      'distance': instance.distance,
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
