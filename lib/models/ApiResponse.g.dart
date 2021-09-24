// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Banner _$BannerFromJson(Map<String, dynamic> json) {
  return Banner(
    json['id'] as int,
    json['title'] as String,
    json['url'] as String,
    BannerFile.fromJson(json['bannerFile'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BannerToJson(Banner instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'bannerFile': instance.bannerFile,
    };

BannerFile _$BannerFileFromJson(Map<String, dynamic> json) {
  return BannerFile(
    json['path'] as String,
  );
}

Map<String, dynamic> _$BannerFileToJson(BannerFile instance) =>
    <String, dynamic>{
      'path': instance.path,
    };
