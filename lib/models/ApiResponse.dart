import 'package:json_annotation/json_annotation.dart';

part 'ApiResponse.g.dart';

@JsonSerializable()

class Banner {
  int id;
  String title;
  String url;
  BannerFile bannerFile;


  Banner(this.id, this.title, this.url, this.bannerFile);

  factory Banner.fromJson(Map<String, dynamic> json) => _$BannerFromJson(json);

  Map<String, dynamic> toJson() => _$BannerToJson(this);
  //
  // Banner({this.id, this.title, this.url, this.bannerFile});
  // Banner.fromJson(Map json)
  //     : id = json['id'],
  //       title = json['title'],
  //       url = json['url'],
  //       bannerFile = BannerFile.fromJson(json['bannerFile']);
}

@JsonSerializable()

class BannerFile {
  String path;


  BannerFile(this.path);

  factory BannerFile.fromJson(Map<String, dynamic> json) => _$BannerFileFromJson(json);

  Map<String, dynamic> toJson() => _$BannerFileToJson(this);


  // BannerFile.fromJson(Map json) : path = json['path'];
}
