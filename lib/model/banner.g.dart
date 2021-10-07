// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) {
  return BannerModel(
    json['banner_id'] as int,
    json['title'] as String,
    json['url'] as String,
    json['path'] as String,
  );
}

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'banner_id': instance.banner_id,
      'title': instance.title,
      'url': instance.url,
      'path': instance.path,
    };
