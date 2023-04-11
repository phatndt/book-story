class UserPostDTO {
  final String imageUrl;
  final String username;
  final String userId;

  UserPostDTO({
    required this.imageUrl,
    required this.username,
    required this.userId,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'username': username,
      'userId': userId,
    };
  }

  factory UserPostDTO.fromMap(Map<dynamic, dynamic> map) {
    return UserPostDTO(
      imageUrl: map['imageUrl'],
      username: map['username'],
      userId: map['userId'],
    );
  }
}
