import 'dart:io';

import 'package:book_exchange/domain/use_cases/upload_image_use_case.dart';

import '../repository/book_repo.dart';

class UploadImageToCloudinaryUseCaseImpl
    extends UploadImageToCloudinaryUseCase {
  final BookRepo _bookRepo;

  UploadImageToCloudinaryUseCaseImpl(this._bookRepo);

  @override
  Future<String?> uploadImageToSpaces(
    String path,
    File file,
  ) async {
    return await _bookRepo.updateImageToSpaces(path, file);
  }
}
