import 'dart:developer';

import 'package:book_exchange/core/route_paths.dart';
import 'package:book_exchange/domain/use_cases/auth/set_verification_user_use_case.dart';
import 'package:book_exchange/domain/use_cases/auth/verify_registration_user_use_case.dart';
import 'package:book_exchange/presentation/models/book_app_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class VerificationState {
  bool isLoadingVerification = false;
  String code;
  VerificationState({
    this.isLoadingVerification = false,
    this.code = "",
  });

  VerificationState copy({
    bool? isLoadingVerification,
    String? code,
  }) =>
      VerificationState(
        isLoadingVerification:
            isLoadingVerification ?? this.isLoadingVerification,
        code: code ?? this.code,
      );
}

class VerificationNotifier extends StateNotifier<VerificationState> {
  VerificationNotifier(
    this.ref,
    this._registrationUserUseCase,
    this._setVerificationUserUseCase,
  ) : super(
          VerificationState(
            isLoadingVerification: false,
            code: "",
          ),
        );

  final Ref ref;
  final VerifyRegistrationUserUseCase _registrationUserUseCase;
  final SetVerificationUserUseCase _setVerificationUserUseCase;

  void setLoadingVerification() {
    final newState =
        state.copy(isLoadingVerification: !state.isLoadingVerification);
    state = newState;
  }

  void setCode(String code) {
    final newState = state.copy(code: code);
    state = newState;
  }

  verifyUser(BuildContext context, String code) {
    setLoadingVerification();
    setCode(code);
    _registrationUserUseCase
        .verifyRegistrationUser(BookAppModel.userRegistrationId, code)
        .then(
      (value) {
        if (value.data) {
          setVerificationUser(context);
        } else {
          setLoadingVerification();
          showTopSnackBar(
            context,
            CustomSnackBar.info(
              message: value.message,
            ),
            displayDuration: const Duration(seconds: 2),
          );
        }
      },
    ).catchError(
      (onError) {
        setLoadingVerification();
        showTopSnackBar(
          context,
          const CustomSnackBar.info(
            message: "Error when verfiy your registration. Please try later!",
          ),
          displayDuration: const Duration(seconds: 2),
        );
      },
    );
  }

  setVerificationUser(BuildContext context) {
    _setVerificationUserUseCase
        .setVerificationUser(BookAppModel.userRegistrationId)
        .then((value) {
      log("successful when setting verification user");
      setLoadingVerification();
      Navigator.pushNamedAndRemoveUntil(
          context, RoutePaths.logIn, (route) => false);
      showTopSnackBar(
        context,
        const CustomSnackBar.info(
          message: "Verification Successfully. Please login your account!",
        ),
        displayDuration: const Duration(seconds: 2),
      );
    }).catchError(
      (onError) {
        log("error when setting verification user");
        setLoadingVerification();
        showTopSnackBar(
          context,
          const CustomSnackBar.info(
            message: "Error when verfiy your registration. Please try later!",
          ),
          displayDuration: const Duration(seconds: 2),
        );
      },
    );
  }
}
