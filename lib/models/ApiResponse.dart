class Banner {
  int id;
  String title;
  String url;
  BannerFile bannerFile;

  Banner({this.id, this.title, this.url, this.bannerFile});

  Banner.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        url = json['url'],
        bannerFile = BannerFile.fromJson(json['bannerFile']);
}

class BannerFile {
  String path;

  BannerFile({this.path});

  BannerFile.fromJson(Map json) : path = json['path'];
}
