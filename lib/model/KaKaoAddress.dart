class KakaoAddressModel {
  // RoadAddress road_address;
  DefaultAddress address;

  KakaoAddressModel.fromJson(Map<String, dynamic> json)
      // : road_address = json["road_address"],
        :address = json["address"];
}

class RoadAddress {
  String address_name;
  String region_1depth_name;
  String region_2depth_name;
  String region_3depth_name;
  String road_name;
  String underground_yn;
  String main_building_no;
  String sub_building_no;
  String building_name;
  String zone_no;

  RoadAddress.fromJson(Map<String, dynamic> json)
      : address_name = json["address_name"],
        region_1depth_name = json["region_1depth_name"],
        region_2depth_name = json["region_2depth_name"],
        region_3depth_name = json["region_3depth_name"],
        road_name = json["road_name"],
        underground_yn = json["underground_yn"],
        main_building_no = json["main_building_no"],
        sub_building_no = json["sub_building_no"],
        building_name = json["building_name"],
        zone_no = json["zone_no"];
}

class DefaultAddress {
  String address_name;
  String region_1depth_name;
  String region_2depth_name;
  String region_3depth_name;
  String mountain_yn;
  String main_address_no;
  String sub_address_no;

  DefaultAddress.fromJson(Map<String, dynamic> json)
      : address_name = json["address_name"],
        region_1depth_name = json["region_1depth_name"],
        region_2depth_name = json["region_2depth_name"],
        region_3depth_name = json["region_3depth_name"],
        mountain_yn = json["mountain_yn"],
        main_address_no = json["main_address_no"],
        sub_address_no = json["sub_address_no"];
}
