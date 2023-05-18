import 'package:book_story/features/authentication/domain/repository/auth_repo.dart';
import 'package:dartz/dartz.dart';

import 'check_logged_use_case.dart';

class CheckLoggedUseCaseImpl extends CheckLoggedUseCase {
  final AuthRepo _authRepo;

  CheckLoggedUseCaseImpl(this._authRepo);

  @override
  Future<Either<Exception, bool>> checkLogged() async {
    return await _authRepo.checkLogged();
  }
}