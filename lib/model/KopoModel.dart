import 'package:json_annotation/json_annotation.dart';

part 'KopoModel.g.dart';

@JsonSerializable()

class KopoModel {
  String postcode;
  String postcode1;
  String postcode2;
  String postcodeSeq;
  // 13494	국가기초구역번호. 2015년 8월 1일부터 시행될 새 우편번호.
  String zonecode;
  // 경기 성남시 분당구 판교역로 235	기본 주소 (검색 결과에서 첫줄에 나오는 주소, 검색어의 타입(지번/도로명)에 따라 달라집니다.)
  String address;
  // 235 Pangyoyeok-ro, Bundang-gu, Seongnam-si, Gyeonggi-do, korea	기본 영문 주소
  String addressEnglish;
  String addressType;
  String bcode;
  String bname;
  String bname1;
  String bname2;
  String sido;
  String sigungu;
  String sigunguCode;
  String userLanguageType;
  String query;
  String buildingName;
  String buildingCode;
  String apartment;
  String jibunAddress;
  String jibunAddressEnglish;
  String roadAddress;
  String roadAddressEnglish;
  String autoRoadAddress;
  String autoRoadAddressEnglish;
  String autoJibunAddress;
  String autoJibunAddressEnglish;
  String userSelectedType;
  String noSelected;
  String hname;
  String roadnameCode;
  String roadname;


  KopoModel(
      this.postcode,
      this.postcode1,
      this.postcode2,
      this.postcodeSeq,
      this.zonecode,
      this.address,
      this.addressEnglish,
      this.addressType,
      this.bcode,
      this.bname,
      this.bname1,
      this.bname2,
      this.sido,
      this.sigungu,
      this.sigunguCode,
      this.userLanguageType,
      this.query,
      this.buildingName,
      this.buildingCode,
      this.apartment,
      this.jibunAddress,
      this.jibunAddressEnglish,
      this.roadAddress,
      this.roadAddressEnglish,
      this.autoRoadAddress,
      this.autoRoadAddressEnglish,
      this.autoJibunAddress,
      this.autoJibunAddressEnglish,
      this.userSelectedType,
      this.noSelected,
      this.hname,
      this.roadnameCode,
      this.roadname);

  factory KopoModel.fromJson(Map<String, dynamic> json) => _$KopoModelFromJson(json);

  Map<String, dynamic> toJson() => _$KopoModelToJson(this);
}
