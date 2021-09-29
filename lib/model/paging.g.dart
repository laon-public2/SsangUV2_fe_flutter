// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paging.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Paging _$PagingFromJson(Map<String, dynamic> json) {
  return Paging(
    json['size'] as int?,
    json['totalPage'] as int?,
    json['currentPage'] as int?,
    json['totalCount'] as int?,
  );
}

Map<String, dynamic> _$PagingToJson(Paging instance) => <String, dynamic>{
      'size': instance.size,
      'totalPage': instance.totalPage,
      'currentPage': instance.currentPage,
      'totalCount': instance.totalCount,
    };
