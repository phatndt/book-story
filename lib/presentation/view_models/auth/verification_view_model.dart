import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  ) : super(
          VerificationState(
            isLoadingVerification: false,
            code: "",
          ),
        );

  final Ref ref;

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

  }

  setVerificationUser(BuildContext context) {

  }
}
