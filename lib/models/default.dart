class ApiResponse<T> {
  int statusCode;
  String message;
  T data;

  ApiResponse({this.statusCode, this.message, this.data});

  ApiResponse.fromJson(Map json)
      : statusCode = json['statusCode'],
        message = json['message'],
        data = json['data'];
}