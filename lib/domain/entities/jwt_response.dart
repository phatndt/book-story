import 'package:book_story/domain/entities/user.dart';

class JwtResponse {
  final String token;
  final User user;

  JwtResponse({required this.token, required this.user});
}
