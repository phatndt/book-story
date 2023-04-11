class ApiResponseDTO<T> {
  final T data;
  final int statusCode;
  final String message;

  ApiResponseDTO(
      {required this.data, required this.statusCode, required this.message});

  Map<dynamic, dynamic> toMap() {
    return {
      'data': data,
      'statusCode': statusCode,
      'message': message,
    };
  }

  factory ApiResponseDTO.fromMap(Map<dynamic, dynamic> map) {
    return ApiResponseDTO(
      data: map['data'],
      statusCode: map['statusCode'],
      message: map['message'],
    );
  }
}
