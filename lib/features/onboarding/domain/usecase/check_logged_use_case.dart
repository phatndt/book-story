import 'package:dartz/dartz.dart';

abstract class CheckLoggedUseCase {
  Future<Either<Exception, bool>> checkLogged();
}