import 'dart:io';

import 'package:book_exchange/domain/repository/profile_repo.dart';

class UploadAvatarUseCase {
  final ProfileRepo _profileRepo;

  UploadAvatarUseCase(this._profileRepo);

  Future<String?> uploadAvatarToCloud(String path, File file) {
    return _profileRepo.uploadAvatarToCloud(path, file);
  }
}
