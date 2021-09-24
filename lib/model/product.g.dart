// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    json['id'] as int,
    json['title'] as String,
    json['description'] as String,
    json['price'] as int,
    json['dateCount'] as int,
    json['createdDate'] as String,
    json['updatedDate'] as String,
    Member.fromJson(json['member'] as Map<String, dynamic>),
    Category.fromJson(json['category'] as Map<String, dynamic>),
    (json['productFiles'] as List<dynamic>)
        .map((e) => ProductFile.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['status'] as String,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'dateCount': instance.dateCount,
      'createdDate': instance.createdDate,
      'updatedDate': instance.updatedDate,
      'member': instance.member,
      'category': instance.category,
      'productFiles': instance.productFiles,
      'status': instance.status,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    json['id'] as int,
    json['name'] as String,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
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
