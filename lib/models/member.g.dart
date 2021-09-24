// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberWithContractCount _$MemberWithContractCountFromJson(
    Map<String, dynamic> json) {
  return MemberWithContractCount(
    Member.fromJson(json['member'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MemberWithContractCountToJson(
        MemberWithContractCount instance) =>
    <String, dynamic>{
      'member': instance.member,
    };

Member _$MemberFromJson(Map<String, dynamic> json) {
  return Member(
    json['id'] as int,
    json['username'] as String,
    json['name'] as String,
    json['provider'] as String,
    json['status'] as String,
    json['withdrawalDate'] as String,
    Address.fromJson(json['address'] as Map<String, dynamic>),
    Kakao.fromJson(json['kakao'] as Map<String, dynamic>),
    Push.fromJson(json['push'] as Map<String, dynamic>),
    json['createdDate'] as String,
    json['updatedDate'] as String,
  );
}

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'provider': instance.provider,
      'status': instance.status,
      'withdrawalDate': instance.withdrawalDate,
      'address': instance.address,
      'kakao': instance.kakao,
      'push': instance.push,
      'createdDate': instance.createdDate,
      'updatedDate': instance.updatedDate,
    };

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
    json['id'] as int,
    json['address'] as String,
    json['detailAddress'] as String,
    json['point'] as String,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'detailAddress': instance.detailAddress,
      'point': instance.point,
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
