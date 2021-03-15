class RegUserPhModel {
  String success;
  String messages;

  RegUserPhModel(this.success, this.messages);

  RegUserPhModel.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        messages = json['message'];
}
