// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StompSendDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StompSendDTO _$StompSendDTOFromJson(Map<String, dynamic> json) {
  return StompSendDTO(
    orderId: json['orderId'] as String?,
    sender: json['sender'] as String?,
    content: json['content'] as String?,
    type: json['type'] as String?,
    createDate: json['createDate'] as String?,
  );
}

Map<String, dynamic> _$StompSendDTOToJson(StompSendDTO instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'sender': instance.sender,
      'content': instance.content,
      'type': instance.type,
      'createDate': instance.createDate,
    };
