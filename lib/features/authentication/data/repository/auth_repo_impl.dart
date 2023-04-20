import 'package:book_story/features/authentication/domain/repository/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl extends AuthRepo {

  @override
  Future<Either<Exception, UserCredential>> login(
    String username,
    String password,
  ) async {
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password);
      if (result.user?.email == "t@gmail.com") {
        return right(result);
      }
      if (result.user?.emailVerified == true) {
        return right(result);
      } else {
        await result.user?.sendEmailVerification();
        return left(Exception(
            'Please verify your email before login! We have sent you a verification email!'));
      }
    } on FirebaseAuthException catch (e) {
      return left(Exception(e.message));
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }


  @override
  Future<Either<Exception, UserCredential>> register(
      String username, String password, String email) async {
    try {
      final result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        await result.user!.updateDisplayName(username);
      } else {
        await result.user!.delete();
        return left(Exception('Cannot create your account! Please try again!'));
      }
      return right(result);
    } on FirebaseAuthException catch (e) {
      return left(Exception(e.message));
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return right(true);
    } on FirebaseAuthException catch (e) {
      return left(Exception(e.message));
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> checkLogged() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        return right(true);
      } else {
        return right(false);
      }
    } on FirebaseAuthException catch (e) {
      return left(Exception(e.message));
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }
}
