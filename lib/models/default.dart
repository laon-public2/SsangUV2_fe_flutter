class ApiResponse<T> {
  late int statusCode;
  late String message;
  late T data;

  ApiResponse({int? statusCode, String? message, T? data });



  ApiResponse.fromJson(Map json)
      : statusCode = json['statusCode'],
        message = json['message'],
        data = json['data'];
}