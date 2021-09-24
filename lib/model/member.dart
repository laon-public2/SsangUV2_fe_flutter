import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  int id;
  String username;
  String name;
  String provider;
  String status;
  DateTime withdrawalDate;
  Address address;
  Kakao kakao;
  Push push;
  DateTime createdDate;
  DateTime updatedDate;


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

  // Member.fromJson(Map<String, dynamic> json)
  //     : id = json['id'],
  //       username = json['username'],
  //       name = json['name'],
  //       provider = json['provider'],
  //       status = json['status'],
  //       withdrawalDate = json['withdrawalDate'],
  //       createdDate = json['createdDate'],
  //       updatedDate = json['updatedDate'],
  //       address = json['address'] != null ? Address.fromJson(json['address']) : Address(),
  //       kakao = json['kakao'] != null ? Kakao.fromJson(json['kakao']) : Kakao(),
  //       push = json['push'] != null ? Push.fromJson(json['push']): Push();
}

@JsonSerializable()
class Address {
  int id;
  String address;
  String detailAddress;

  Address(this.id, this.address, this.detailAddress);

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