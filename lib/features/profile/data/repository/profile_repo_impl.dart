import 'dart:io';

import 'package:book_story/features/profile/domain/repository/profile_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileRepoImpl extends ProfileRepo {
  @override
  Future<Either<Exception, String>> getProfileName() async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        return left(Exception('user_is_null_login_again'.tr()));
      }
      return right(FirebaseAuth.instance.currentUser?.displayName ?? '');
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, String>> getProfilePhotoUrl() async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        return left(Exception('user_is_null_login_again'.tr()));
      }
      return right(FirebaseAuth.instance.currentUser?.photoURL ?? '');
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> updateProfileName(String name) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        return left(Exception('user_is_null_login_again'.tr()));
      }
      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
      return right(true);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<void> updateProfilePassword(String password) {
    // TODO: implement updateProfilePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, bool>> updateProfilePhotoUrl(File photo) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        return left(Exception('user_is_null_login_again'.tr()));
      }
      final String fileName = photo.path.split('/').last;
      final result = await FirebaseStorage.instance
          .ref()
          .child('users/${FirebaseAuth.instance.currentUser!.uid}/profile/avatar/$fileName')
          .putFile(photo);
      final url = await result.ref.getDownloadURL();
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(url);
      return right(true);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }
}
