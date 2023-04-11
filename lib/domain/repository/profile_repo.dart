import 'dart:io';

import '../entities/api_response.dart';
import '../entities/user.dart';

abstract class ProfileRepo {
  Future<ApiResponse<String>> changePassword(
    String username,
    String oldPassword,
    String newPassword,
    String token,
  );

  Future<ApiResponse<String>> changeAddress(
    String address,
    String token,
    String id,
  );
  Future<ApiResponse<String>> changeUsername(
    String username,
    String token,
    String id,
  );
  Future<ApiResponse<String>> changeAvatarPath(
    String avatarPath,
    String token,
    String id,
  );

  Future<String?> uploadAvatarToCloud(
    String path,
    File file,
  );

  Future<ApiResponse<User>> getUser(
    String userId,
    String token,
  );
}
