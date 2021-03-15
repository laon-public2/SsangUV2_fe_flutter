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
      {this.id,
        this.username,
        this.name,
        this.provider,
        this.status,
        this.withdrawalDate,
        this.address,
        this.kakao,
        this.push,
        this.createdDate,
        this.updatedDate});

  Member.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        name = json['name'],
        provider = json['provider'],
        status = json['status'],
        withdrawalDate = json['withdrawalDate'],
        createdDate = json['createdDate'],
        updatedDate = json['updatedDate'],
        address = json['address'] != null ? Address.fromJson(json['address']) : Address(),
        kakao = json['kakao'] != null ? Kakao.fromJson(json['kakao']) : Kakao(),
        push = json['push'] != null ? Push.fromJson(json['push']): Push();
}

class Address {
  int id;
  String address;
  String detailAddress;

  Address({this.id, this.address, this.detailAddress});

  Address.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        address = json['address'],
        detailAddress = json['detailAddress'];
}

class Kakao {
  int id;
  String profile;

  Kakao({this.id, this.profile});

  Kakao.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        profile = json['profile'];
}

class Push {
  int id;
  String token;

  Push({this.id, this.token});

  Push.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        token = json['token'];
}