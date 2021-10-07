// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductDetailWant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

productDetailWant _$productDetailWantFromJson(Map<String, dynamic> json) {
  return productDetailWant(
    json['idx'] as int,
    json['title'] as String,
    json['receiver_idx'] as int?,
    json['price'] as int,
    json['min_price'] as int,
    json['max_price'] as int,
    json['category_idx'] as int?,
    json['description'] as String,
    json['type'] as String,
    json['start_date'] as String,
    json['end_date'] as String,
    json['address'] as String,
    json['address_detail'] as String,
    json['name'] as String,
    json['review_possible'] as bool?,
    json['lati'] as num?,
    json['longti'] as num?,
    json['distance'] as num?,
    json['fcm_token'] as String,
    (json['image'] as List<dynamic>)
        .map((e) => ProductFile.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$productDetailWantToJson(productDetailWant instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'title': instance.title,
      'receiver_idx': instance.receiver_idx,
      'price': instance.price,
      'min_price': instance.min_price,
      'max_price': instance.max_price,
      'category_idx': instance.category_idx,
      'description': instance.description,
      'type': instance.type,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'address': instance.address,
      'address_detail': instance.address_detail,
      'name': instance.name,
      'review_possible': instance.review_possible,
      'lati': instance.lati,
      'longti': instance.longti,
      'distance': instance.distance,
      'fcm_token': instance.fcm_token,
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

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    json['y'] as num,
    json['x'] as num,
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'y': instance.y,
      'x': instance.x,
    };
