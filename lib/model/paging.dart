import 'package:json_annotation/json_annotation.dart';

part 'paging.g.dart';

@JsonSerializable()
class Paging {
  // int? size;
  // int? totalPage;
  int? currentPage;
  int? totalCount;

  Paging(this.currentPage, this.totalCount);
  // Paging(this.size, this.totalPage, this.currentPage, this.totalCount);

  factory Paging.fromJson(Map<String, dynamic> json) => _$PagingFromJson(json);

  Map<String, dynamic> toJson() => _$PagingToJson(this);
}