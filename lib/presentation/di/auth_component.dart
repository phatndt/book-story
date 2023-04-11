import 'package:book_exchange/data/repos/auth_repo_impl.dart';
import 'package:book_exchange/data/services/auth_service.dart';
import 'package:book_exchange/domain/use_cases/auth/send_email_use_case.dart';
import 'package:book_exchange/domain/use_cases/auth/send_email_use_case_impl.dart';
import 'package:book_exchange/domain/use_cases/auth/set_verification_user_use_case.dart';
import 'package:book_exchange/domain/use_cases/auth/set_verification_user_use_case_impl.dart';
import 'package:book_exchange/domain/use_cases/auth/verify_registration_user_use_case.dart';
import 'package:book_exchange/presentation/view_models/auth/verification_view_model.dart';
import 'package:book_exchange/presentation/view_models/sign_up_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/use_cases/auth/check_exist_username_use_case_impl.dart';
import '../../domain/use_cases/auth/login_use_case_impl.dart';
import '../../domain/use_cases/auth/register_use_case.dart';
import '../../domain/use_cases/auth/register_use_case_impl.dart';
import '../../domain/use_cases/auth/verify_registration_user_use_case_impl.dart';
import '../view_models/login_viewmodel.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authRepoProvider = Provider<AuthRepoImpl>(
    (ref) => AuthRepoImpl(ref.watch(authServiceProvider)));

final loginUseCaseProvider = Provider<LoginUseCaseImpl>(
    (ref) => LoginUseCaseImpl(ref.watch(authRepoProvider)));

final loginSettingNotifierProvider =
    StateNotifierProvider.autoDispose<LoginSettingNotifier, LoginSetting>(
        ((ref) => LoginSettingNotifier(ref, ref.watch(loginUseCaseProvider))));

final checkExistUsernameUseCaseProvider =
    Provider<CheckExistUsernameUseCaseImpl>(
        (ref) => CheckExistUsernameUseCaseImpl(ref.watch(authRepoProvider)));

final registerUseCaseProvider = Provider<RegisterUseCase>(
    (ref) => RegisterUseCaseImpl(ref.watch(authRepoProvider)));

final sendEmailUseCaseProvider = Provider<SendEmailUseCase>(
    (ref) => SendEmailUseCaseImpl(ref.watch(authRepoProvider)));

final registerSettingNotifierProvider =
    StateNotifierProvider<RegisterSettingNotifier, RegisterSetting>(
  ((ref) => RegisterSettingNotifier(
        ref,
        ref.watch(checkExistUsernameUseCaseProvider),
        ref.watch(registerUseCaseProvider),
        ref.watch(sendEmailUseCaseProvider),
      )),
);

final verifyRegistrationUserUseCaseProvider =
    Provider<VerifyRegistrationUserUseCase>((ref) =>
        VerifyRegistrationUserUseCaseImpl(ref.watch(authRepoProvider)));

        
final setVerificationUserUseCaseProvider =
    Provider<SetVerificationUserUseCase>((ref) =>
        SetVerificationUserUseCaseImpl(ref.watch(authRepoProvider)));

final verificationStateNotifierProvider =
    StateNotifierProvider<VerificationNotifier, VerificationState>(
        (ref) => VerificationNotifier(
              ref,
              ref.watch(verifyRegistrationUserUseCaseProvider),
              ref.watch(setVerificationUserUseCaseProvider),
            ));
