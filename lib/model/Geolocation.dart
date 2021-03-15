class Geolocation {
  String addressName;
  String depth1;
  String depth2;
  String depth3;
  String depth4;

  Geolocation.fromJson(Map<String, dynamic> json)
      : addressName = json['address_name'],
        depth1 = json['region_1depth_name'],
        depth2 = json['region_2depth_name'],
        depth3 = json['region_3depth_name'],
        depth4 = json['region_4depth_name'];
}
