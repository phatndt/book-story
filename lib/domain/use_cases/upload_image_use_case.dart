import 'dart:io';

abstract class UploadImageToCloudinaryUseCase {
  Future<String?> uploadImageToSpaces(
    String path,
    File file,
  );
}
