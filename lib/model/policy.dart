class PolicyModel {
  String title;
  String content;

  PolicyModel(this.title, this.content);

  PolicyModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        content = json['content'];
}