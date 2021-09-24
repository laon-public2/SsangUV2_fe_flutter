// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) {
  return Member(
    json['id'] as int,
    json['username'] as String,
    json['name'] as String,
    json['provider'] as String,
    json['status'] as String,
    DateTime.parse(json['withdrawalDate'] as String),
    Address.fromJson(json['address'] as Map<String, dynamic>),
    Kakao.fromJson(json['kakao'] as Map<String, dynamic>),
    Push.fromJson(json['push'] as Map<String, dynamic>),
    DateTime.parse(json['createdDate'] as String),
    DateTime.parse(json['updatedDate'] as String),
  );
}

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'provider': instance.provider,
      'status': instance.status,
      'withdrawalDate': instance.withdrawalDate.toIso8601String(),
      'address': instance.address,
      'kakao': instance.kakao,
      'push': instance.push,
      'createdDate': instance.createdDate.toIso8601String(),
      'updatedDate': instance.updatedDate.toIso8601String(),
    };

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
    json['id'] as int,
    json['address'] as String,
    json['detailAddress'] as String,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'detailAddress': instance.detailAddress,
    };

Kakao _$KakaoFromJson(Map<String, dynamic> json) {
  return Kakao(
    json['id'] as int,
    json['profile'] as String,
  );
}

Map<String, dynamic> _$KakaoToJson(Kakao instance) => <String, dynamic>{
      'id': instance.id,
      'profile': instance.profile,
    };

Push _$PushFromJson(Map<String, dynamic> json) {
  return Push(
    json['id'] as int,
    json['token'] as String,
  );
}

Map<String, dynamic> _$PushToJson(Push instance) => <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
    };
