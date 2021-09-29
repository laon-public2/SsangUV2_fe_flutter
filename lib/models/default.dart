class ApiResponse<T> {
  int? statusCode;
  String? message;
  T? data;

  ApiResponse({required int statusCode, required String message, required T data });



  ApiResponse.fromJson(Map json)
      : statusCode = json['statusCode'],
        message = json['message'],
        data = json['data'];
}