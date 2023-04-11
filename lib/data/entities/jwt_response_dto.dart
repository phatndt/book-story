import 'user_dto.dart';

class JwtResponseDTO {
  final String token;
  final UserDTO user;

  JwtResponseDTO({
    required this.token,
    required this.user,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'token': token,
      'user': user,
    };
  }

  factory JwtResponseDTO.fromMap(Map<dynamic, dynamic> map) {
    return JwtResponseDTO(
      token: map['token'],
      user: UserDTO.fromMap(map['user']),
    );
  }
}
