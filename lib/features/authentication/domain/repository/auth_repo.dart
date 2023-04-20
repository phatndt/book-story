import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepo {
  Future<Either<Exception, UserCredential>> login(
    String username,
    String password,
  );

  Stream<User?> authStateChanges();

  Future<Either<Exception, UserCredential>> register(
    String username,
    String password,
    String email,
  );

  Future<Either<Exception, bool>> resetPassword(String email);
  Future<Either<Exception, bool>> checkLogged();
}
