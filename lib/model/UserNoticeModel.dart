class UserNoticeModel {
  int userIdx;
  num targetUserIdx;
  int productIdx;
  String status;
  String createAt;
  String receiver;
  UserNoticeModel(this.userIdx, this.targetUserIdx, this.productIdx, this.status, this.createAt, this.receiver);

  UserNoticeModel.fromJson(Map<String, dynamic> json)
      : userIdx = json['user_idx'],
        targetUserIdx = json['target_user_idx'],
        productIdx = json['product_idx'],
        status = json['status'],
        createAt = json['created_at'],
        receiver = json['receiver_name'];
}
