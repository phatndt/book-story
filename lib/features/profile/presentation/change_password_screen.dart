import 'package:book_story/core/widget/app_bar.dart';
import 'package:book_story/features/profile/di/profile_module.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/colors/colors.dart';
import '../../../core/presentation/state.dart';
import '../../../core/widget/custom_elevated_button.dart';
import '../../../core/widget/custom_text_form_fill.dart';
import '../../../core/widget/snack_bar.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  late TextEditingController oldPasswordController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;
  late bool isShowClearIconOldPasswordController;
  late bool isShowClearIconPasswordController;
  late bool isShowClearIconPasswordConfirmController;
  late bool isObscureOldPasswordController;
  late bool isObscurePasswordController;
  late bool isObscurePasswordConfirmController;
  late bool isLoading;
  late FocusNode confirmPasswordFocusNode;
  late FocusNode confirmNewPasswordFocusNode;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    isShowClearIconOldPasswordController = false;
    isShowClearIconPasswordController = false;
    isShowClearIconPasswordConfirmController = false;
    oldPasswordController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
    isObscureOldPasswordController = true;
    isObscurePasswordController = true;
    isObscurePasswordConfirmController = true;
    confirmPasswordFocusNode = FocusNode();
    confirmNewPasswordFocusNode = FocusNode();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(changePasswordStateNotifierProvider, (previous, next) {
      if (next is UILoadingState) {
        setState(() {
          isLoading = next.loading;
        });
      } else if (next is UISuccessState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SuccessSnackBar(message: next.data.toString()));
        Navigator.pop(context);
      } else if (next is UIErrorState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(ErrorSnackBar(message: next.error.toString()));
      }
    });
    return SafeArea(
      child: Form(
        key: _formKey,
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
              appBar: CustomAppBar(
                title: Text(
                  'change_password'.tr(),
                  style: S.textStyles.heading3,
                ),
                leading: BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: S.colors.primary_3,
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomTextFormField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            isShowClearIconOldPasswordController = true;
                          });
                        } else {
                          setState(() {
                            isShowClearIconOldPasswordController = false;
                          });
                        }
                      },
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'authentication.login.please_enter_your_password'
                                .tr();
                          } else if (value.length < 6) {
                            return 'authentication.register.your_password_at_least_six_character'
                                .tr();
                          }
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        confirmPasswordFocusNode.requestFocus();
                      },
                      hintText: 'authentication.login.password'.tr(),
                      obscureText: isObscureOldPasswordController,
                      controller: oldPasswordController,
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      suffixIconData: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isShowClearIconOldPasswordController
                              ? InkWell(
                                  child: const Icon(Icons.clear),
                                  onTap: () {
                                    oldPasswordController.clear();
                                    setState(() {
                                      isShowClearIconOldPasswordController =
                                          false;
                                    });
                                  },
                                )
                              : const SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                          IconButton(
                            padding: const EdgeInsets.only(),
                            splashColor: Colors.transparent,
                            icon: isObscureOldPasswordController
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isObscureOldPasswordController =
                                    !isObscureOldPasswordController;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomTextFormField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            isShowClearIconPasswordController = true;
                          });
                        } else {
                          setState(() {
                            isShowClearIconPasswordController = false;
                          });
                        }
                      },
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'authentication.login.please_enter_your_password'
                                .tr();
                          } else if (value.length < 6) {
                            return 'authentication.register.your_password_at_least_six_character'
                                .tr();
                          }
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        confirmNewPasswordFocusNode.requestFocus();
                      },
                      hintText: 'authentication.login.password'.tr(),
                      obscureText: isObscurePasswordController,
                      controller: passwordController,
                      focusNode: confirmPasswordFocusNode,
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      suffixIconData: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isShowClearIconPasswordController
                              ? InkWell(
                                  child: const Icon(Icons.clear),
                                  onTap: () {
                                    passwordController.clear();
                                    setState(() {
                                      isShowClearIconPasswordController = false;
                                    });
                                  },
                                )
                              : const SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                          IconButton(
                            padding: const EdgeInsets.only(),
                            splashColor: Colors.transparent,
                            icon: isObscurePasswordController
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isObscurePasswordController =
                                    !isObscurePasswordController;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomTextFormField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            isShowClearIconPasswordConfirmController = true;
                          });
                        } else {
                          setState(() {
                            isShowClearIconPasswordConfirmController = false;
                          });
                        }
                      },
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'authentication.login.please_enter_your_password'
                                .tr();
                          } else if (value.length < 6) {
                            return 'authentication.register.your_password_at_least_six_character'
                                .tr();
                          } else if (value != passwordController.text) {
                            return 'authentication.register.password_not_matching'.tr();
                          }
                        }
                        return null;
                      },
                      hintText: 'authentication.register.confirm_password'.tr(),
                      obscureText: isObscurePasswordConfirmController,
                      controller: passwordConfirmController,
                      focusNode: confirmNewPasswordFocusNode,
                      textInputAction: TextInputAction.done,
                      inputType: TextInputType.text,
                      suffixIconData: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isShowClearIconPasswordConfirmController
                              ? InkWell(
                                  child: const Icon(Icons.clear),
                                  onTap: () {
                                    passwordConfirmController.clear();
                                    setState(() {
                                      isShowClearIconPasswordConfirmController =
                                          false;
                                    });
                                  },
                                )
                              : const SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                          IconButton(
                            padding: const EdgeInsets.only(),
                            splashColor: Colors.transparent,
                            icon: isObscurePasswordConfirmController
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isObscurePasswordConfirmController =
                                    !isObscurePasswordConfirmController;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomElevatedButton(
                      child: Center(
                        child: Text(
                          'change_password'.tr(),
                          style: S.textStyles.button
                              .copyWith(color: S.colors.white),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref
                              .watch(
                                  changePasswordStateNotifierProvider.notifier)
                              .changePassword(
                                oldPasswordController.text.trim(),
                                passwordController.text.trim(),
                              );
                        }
                      },
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
