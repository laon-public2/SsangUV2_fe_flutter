import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class MemberWithContractCount {
  // int purchaseCount;
  // int borrowCount;
  Member member;

  MemberWithContractCount(this.member);


  factory MemberWithContractCount.fromJson(Map<String, dynamic> json) => _$MemberWithContractCountFromJson(json);

  Map<String, dynamic> toJson() => _$MemberWithContractCountToJson(this);

}

@JsonSerializable()
class Member {
  int id;
  String username;
  String name;
  String provider;
  String status;
  String withdrawalDate;
  Address address;
  Kakao kakao;
  Push push;
  String createdDate;
  String updatedDate;

  Member(
      this.id,
      this.username,
      this.name,
      this.provider,
      this.status,
      this.withdrawalDate,
      this.address,
      this.kakao,
      this.push,
      this.createdDate,
      this.updatedDate);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  Map<String, dynamic> toJson() => _$MemberToJson(this);

}

@JsonSerializable()
class Address {
  int id;
  String address;
  String detailAddress;
  String point;


  Address(this.id, this.address, this.detailAddress, this.point);

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

}

@JsonSerializable()
class Kakao {
  int id;
  String profile;


  Kakao(this.id, this.profile);

  factory Kakao.fromJson(Map<String, dynamic> json) => _$KakaoFromJson(json);

  Map<String, dynamic> toJson() => _$KakaoToJson(this);

}

@JsonSerializable()
class Push {
  int id;
  String token;


  Push(this.id, this.token);

  factory Push.fromJson(Map<String, dynamic> json) => _$PushFromJson(json);

  Map<String, dynamic> toJson() => _$PushToJson(this);
}
