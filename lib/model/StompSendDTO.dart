import 'package:json_annotation/json_annotation.dart';

part 'StompSendDTO.g.dart';

@JsonSerializable()


class StompSendDTO {
  String? orderId;
  String? sender;
  String? content;
  String? type;
  String? createDate;

  StompSendDTO({this.orderId, this.sender, this.content, this.type, this.createDate});

  // StompSendDTO(
  //     this.orderId, this.sender, this.content, this.type, this.createAt);


  factory StompSendDTO.fromJson(Map<String, dynamic> json) => _$StompSendDTOFromJson(json);

  Map<String, dynamic> toJson() => _$StompSendDTOToJson(this);
}
