import 'package:jwt_decode/jwt_decode.dart';

String getUserIdFromToken(String token) {
  Map<String, dynamic> payload = Jwt.parseJwt(token);
  String userId = payload['userId'];
  return userId;
}

String getUsernameFromToken(String token) {
  Map<String, dynamic> payload = Jwt.parseJwt(token);
  String userId = payload['sub'];
  return userId;
}
