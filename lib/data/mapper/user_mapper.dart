import 'package:book_story/data/base/base_mapper.dart';
import 'package:book_story/data/entities/user_dto.dart';
import 'package:book_story/domain/entities/user.dart';

class UserMapper extends BaseMapper<UserDTO, User> {
  @override
  User transfer(UserDTO d) {
    return User(
      d.id,
      d.name,
      d.password,
      d.email,
      d.address,
      d.image,
      d.isVerified,
      d.isDeleted,
    );
  }
}
