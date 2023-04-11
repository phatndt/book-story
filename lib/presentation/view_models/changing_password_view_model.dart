import 'package:book_exchange/core/extension/function_extension.dart';
import 'package:book_exchange/core/route_paths.dart';
import 'package:book_exchange/domain/use_cases/change_pasword_use_case.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../core/core.dart';
import '../models/book_app_model.dart';

class ChangingPasswordSetting {
  final TextEditingController oldPassword;
  final TextEditingController passwordController;
  final TextEditingController confirmPassword;

  bool isLoadingProfile = false;
  bool isOldPasswordVisible = true;
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;

  ChangingPasswordSetting({
    required this.oldPassword,
    required this.passwordController,
    required this.confirmPassword,
    this.isLoadingProfile = false,
    this.isOldPasswordVisible = false,
    this.isPasswordVisible = true,
    this.isConfirmPasswordVisible = true,
  });

  ChangingPasswordSetting copy({
    TextEditingController? oldPassword,
    TextEditingController? passwordController,
    TextEditingController? confirmPassword,
    bool? isLoadingProfile,
    bool? isOldPasswordVisible,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) =>
      ChangingPasswordSetting(
        oldPassword: oldPassword ?? this.oldPassword,
        passwordController: passwordController ?? this.passwordController,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
        isOldPasswordVisible: isOldPasswordVisible ?? this.isOldPasswordVisible,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        isConfirmPasswordVisible:
            isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      );

  void clearEmail() {
    oldPassword.clear();
  }

  get oldPasswordVisible => isOldPasswordVisible;
  get passwordVisible => isPasswordVisible;
  get loadingProfile => isLoadingProfile;
  get confirmPasswordVisible => isConfirmPasswordVisible;
}

class ChangingPasswordNotifier extends StateNotifier<ChangingPasswordSetting> {
  ChangingPasswordNotifier(this.ref, this._changePasswordUseCase)
      : super(
          ChangingPasswordSetting(
            oldPassword: TextEditingController(),
            passwordController: TextEditingController(),
            confirmPassword: TextEditingController(),
            isOldPasswordVisible: true,
            isPasswordVisible: true,
            isConfirmPasswordVisible: true,
            isLoadingProfile: false,
          ),
        );

  final Ref ref;
  // late AuthRepo _authRepo;
  final ChangePasswordUseCase _changePasswordUseCase;

  void setOldPasswordVisible() {
    final newState =
        state.copy(isOldPasswordVisible: !state.isOldPasswordVisible);
    state = newState;
  }

  void setPasswordVisible() {
    final newState = state.copy(isPasswordVisible: !state.isPasswordVisible);
    state = newState;
  }

  void setConfirmPasswordVisible() {
    final newState =
        state.copy(isConfirmPasswordVisible: !state.isConfirmPasswordVisible);
    state = newState;
  }

  void setLoadingProfile() {
    final newState = state.copy(isLoadingProfile: !state.isLoadingProfile);
    state = newState;
  }

  changePassword(context) {
    setLoadingProfile();
    if (!validateInformation()) {
      showTopSnackBar(
        context,
        const CustomSnackBar.info(
          message: "Wrong password",
        ),
        displayDuration: const Duration(seconds: 2),
      );
      setLoadingProfile();
    } else {
      _changePasswordUseCase
          .changePassword(
              getUsernameFromToken(BookAppModel.jwtToken),
              state.oldPassword.text,
              state.passwordController.text,
              BookAppModel.jwtToken)
          .then(
        (value) {
          Navigator.pushReplacementNamed(context, RoutePaths.logIn);
          setLoadingProfile();
        },
      ).catchError(
        (onError) {
          setLoadingProfile();
          catchOnError(context, onError);
        },
      );
    }
  }

  validateInformation() {
    if (state.oldPassword.text.isEmpty ||
        state.passwordController.text.isEmpty ||
        state.confirmPassword.text.isEmpty ||
        state.passwordController.text != state.confirmPassword.text) {
      return false;
    } else {
      return true;
    }
  }
}
