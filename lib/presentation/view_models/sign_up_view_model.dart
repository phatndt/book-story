import 'package:book_exchange/core/route_paths.dart';
import 'package:book_exchange/presentation/models/book_app_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../domain/use_cases/auth/check_exist_username_use_case.dart';
import '../../domain/use_cases/auth/register_use_case.dart';
import '../../domain/use_cases/auth/send_email_use_case.dart';

class RegisterSetting {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController usernameController;

  bool isLoadingRegister = false;
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;

  RegisterSetting({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.usernameController,
    this.isLoadingRegister = false,
    this.isPasswordVisible = true,
    this.isConfirmPasswordVisible = true,
  });

  RegisterSetting copy({
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
    TextEditingController? usernameController,
    bool? isLoadingRegister,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) =>
      RegisterSetting(
        emailController: emailController ?? this.emailController,
        passwordController: passwordController ?? this.passwordController,
        confirmPasswordController:
            confirmPasswordController ?? this.confirmPasswordController,
        usernameController: usernameController ?? this.usernameController,
        isLoadingRegister: isLoadingRegister ?? this.isLoadingRegister,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        isConfirmPasswordVisible:
            isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      );

  void clearEmail() {
    emailController.clear();
  }

  get passwordVisible => isPasswordVisible;
  get loadingRegister => isLoadingRegister;
  get confirmPasswordVisible => isConfirmPasswordVisible;
}

class RegisterSettingNotifier extends StateNotifier<RegisterSetting> {
  RegisterSettingNotifier(
    this.ref,
    this._checkExistUsernameUseCaseImpl,
    this._registerUseCaseImpl,
    this._sendEmailUseCase,
  ) : super(
          RegisterSetting(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            confirmPasswordController: TextEditingController(),
            usernameController: TextEditingController(),
            isPasswordVisible: true,
            isLoadingRegister: false,
          ),
        );

  final Ref ref;
  final CheckExistUsernameUseCase _checkExistUsernameUseCaseImpl;
  final RegisterUseCase _registerUseCaseImpl;
  final SendEmailUseCase _sendEmailUseCase;

  void setPasswordVisible() {
    final newState = state.copy(isPasswordVisible: !state.isPasswordVisible);
    state = newState;
  }

  void setLoadingRegister() {
    final newState = state.copy(isLoadingRegister: !state.isLoadingRegister);
    state = newState;
  }

  void setConfirmPasswordVisible() {
    final newState =
        state.copy(isConfirmPasswordVisible: !state.isConfirmPasswordVisible);
    state = newState;
  }

  void clearEmail() {
    final newState = state.copy(emailController: TextEditingController());
    state = newState;
  }

  void clearUsername() {
    final newState = state.copy(usernameController: TextEditingController());
    state = newState;
  }

  register(context) {
    if (state.emailController.text.isNotEmpty ||
        state.passwordController.text.isNotEmpty) {
      _registerUseCaseImpl
          .register(
        state.usernameController.text,
        state.passwordController.text,
        state.emailController.text,
      )
          .then((value) {
        if (value.statusCode == 200) {
          BookAppModel.userRegistrationId = value.data;
          sendEmail(value.data, context);
        } else {
          setLoadingRegister();
          showTopSnackBar(
            context,
            const CustomSnackBar.info(
              message: "Error when register. Please try later!",
            ),
            displayDuration: const Duration(seconds: 2),
          );
        }
      }).catchError(
        (onError) {
          setLoadingRegister();
          showTopSnackBar(
            context,
            CustomSnackBar.info(
              message: "Error: $onError",
            ),
            displayDuration: const Duration(seconds: 2),
          );
        },
      );
    } else {
      setLoadingRegister();
      showTopSnackBar(
        context,
        const CustomSnackBar.info(
          message: "Please enter username and password",
        ),
      );
    }
  }

  sendEmail(String userId, BuildContext context) {
    _sendEmailUseCase.sendEmail(userId).then((value) {
      setLoadingRegister();
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutePaths.verifyEmail,
        (route) => false,
      );
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.info(
      //     message: value.message,
      //   ),
      //   displayDuration: const Duration(seconds: 2),
      // );
    }).catchError(
      (onError) {
        setLoadingRegister();
        showTopSnackBar(
          context,
          CustomSnackBar.info(
            message: "Error: $onError",
          ),
          displayDuration: const Duration(seconds: 2),
        );
      },
    );
  }

  checkExistEmail(context) async {
    setLoadingRegister();
    if (state.emailController.text.isNotEmpty ||
        state.passwordController.text.isNotEmpty ||
        state.usernameController.text.isNotEmpty ||
        state.confirmPasswordController.text.isNotEmpty) {
      await _checkExistUsernameUseCaseImpl
          .checkExistEmail(state.emailController.text)
          .then((value) {
        if (value.data) {
          setLoadingRegister();
          showTopSnackBar(
            context,
            CustomSnackBar.info(
              message: value.message,
            ),
            displayDuration: const Duration(seconds: 2),
          );
        } else {
          register(context);
        }
      }).catchError(
        (onError) {
          setLoadingRegister();
          showTopSnackBar(
            context,
            CustomSnackBar.info(
              message: "Error: $onError",
            ),
            displayDuration: const Duration(seconds: 2),
          );
        },
      );
    } else {
      setLoadingRegister();
      showTopSnackBar(
        context,
        const CustomSnackBar.info(
          message: "Please enter information!",
        ),
      );
    }
  }
}
