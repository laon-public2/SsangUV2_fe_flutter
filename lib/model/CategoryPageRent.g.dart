// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CategoryPageRent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryPageRent _$CategoryPageRentFromJson(Map<String, dynamic> json) {
  return CategoryPageRent(
    json['id'] as int,
    json['title'] as String,
    json['price'] as int,
    json['category_idx'] as int?,
    json['name'] as String,
    json['distance'] as num,
    (json['productFiles'] as List<dynamic>)
        .map((e) => ProductFile.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$CategoryPageRentToJson(CategoryPageRent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'category_idx': instance.category,
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
