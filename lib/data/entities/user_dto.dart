class UserDTO {
  final String id;
  final String name;
  final String password;
  final String email;
  final String address;
  final String image;
  final bool isVerified;
  final bool isDeleted;

  UserDTO({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.address,
    required this.image,
    required this.isVerified,
    required this.isDeleted,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'id ': id,
      'username': name,
      'password': password,
      'email': email,
      'address': address,
      'image': image,
      'isVerified': isVerified,
      'isDeleted': isDeleted,
    };
  }

  factory UserDTO.fromMap(Map<dynamic, dynamic> map) {
    return UserDTO(
      id: map['id'],
      name: map['name'],
      password: map['password'],
      email: map['email'],
      address: map['address'],
      image: map['imageUrl'],
      isVerified: map['verified'],
      isDeleted: map['deleted'],
    );
  }
}
