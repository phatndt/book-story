import 'dart:io';

import 'package:dartz/dartz.dart';

abstract class ProfileRepo {
Future<Either<Exception, String>> getProfileName();
  Future<Either<Exception, String>> getProfilePhotoUrl();
  Future<Either<Exception, bool>> updateProfileName(String name);
  Future<Either<Exception, bool>> updateProfilePhotoUrl(File photo);
  Future<Either<Exception, bool>> updateProfilePassword(String oldPassword, String newPassword);
  Future<void> logOut();
Future<Either<Exception, String>> getEmail();
}