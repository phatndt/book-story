import 'package:book_story/features/authentication/di/authentication_module.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/colors/colors.dart';
import '../../../core/presentation/state.dart';
import '../../../core/widget/custom_elevated_button.dart';
import '../../../core/widget/custom_text_form_fill.dart';
import '../../../core/widget/snack_bar.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;
  late bool isShowClearIconEmailController;
  late bool isShowClearIconNameController;
  late bool isObscurePasswordController;
  late bool isObscurePasswordConfirmController;
  late bool isShowClearIconPasswordController;
  late bool isShowClearIconPasswordConfirmController;
  late bool isLoading;
  late FocusNode confirmPasswordFocusNode;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    emailController = TextEditingController();
    nameController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
    isShowClearIconEmailController = false;
    isShowClearIconNameController = false;
    isObscurePasswordController = true;
    isObscurePasswordConfirmController = true;
    isShowClearIconPasswordController = false;
    isShowClearIconPasswordConfirmController = false;
    isLoading = false;
    confirmPasswordFocusNode = FocusNode();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registerStateNotifierProvider, (previous, next) {
      if (next is UISuccessState) {
        setState(() {
          isLoading = false;
        });
        final snackBar = SuccessSnackBar(
          message: 'authentication.register.successfully'.tr(),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      } else if (next is UIErrorState) {
        setState(() {
          isLoading = false;
        });
        final snackBar = ErrorSnackBar(
          message: next.error.toString(),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: S.size.length_40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: S.size.length_40Vertical,
                    ),
                    Image.asset(
                      'assets/logo/logo.png',
                      width: 100.w,
                      height: 100.h,
                    ),
                    SizedBox(
                      height: S.size.length_40Vertical,
                    ),
                    Text(
                      'authentication.register.register_1'.tr(),
                      style: S.textStyles.heading1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: S.colors.primary_3),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomTextFormField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            isShowClearIconNameController = true;
                          });
                        } else {
                          setState(() {
                            isShowClearIconNameController = false;
                          });
                        }
                      },
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'authentication.register.please_enter_your_name'
                                .tr();
                          } else if (value.length < 2) {
                            return 'authentication.register.your_name_at_least_one_character'
                                .tr();
                          }
                        }
                        return null;
                      },
                      hintText: 'authentication.register.name'.tr(),
                      obscureText: false,
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.name,
                      suffixIconData: isShowClearIconNameController
                          ? IconButton(
                              splashColor: Colors.transparent,
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                nameController.clear();
                                setState(() {
                                  isShowClearIconNameController = false;
                                });
                              },
                            )
                          : null,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomTextFormField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            isShowClearIconEmailController = true;
                          });
                        } else {
                          setState(() {
                            isShowClearIconEmailController = false;
                          });
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'authentication.login.please_enter_your_email'
                              .tr();
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'authentication.login.please_enter_valid_email'
                              .tr();
                        }
                        return null;
                      },
                      hintText: 'authentication.login.email'.tr(),
                      obscureText: false,
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.emailAddress,
                      suffixIconData: isShowClearIconEmailController
                          ? IconButton(
                              splashColor: Colors.transparent,
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                emailController.clear();
                                setState(() {
                                  isShowClearIconEmailController = false;
                                });
                              },
                            )
                          : null,
                    ),
                    SizedBox(
                      height: 16.h,
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
                        confirmPasswordFocusNode.requestFocus();
                      },
                      hintText: 'authentication.login.password'.tr(),
                      obscureText: isObscurePasswordController,
                      controller: passwordController,
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
                      height: 16.h,
                    ),
                    CustomTextFormField(
                      focusNode: confirmPasswordFocusNode,
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
                            return 'password_not_matching'.tr();
                          }
                        }
                        return null;
                      },
                      hintText: 'authentication.register.confirm_password'.tr(),
                      obscureText: isObscurePasswordConfirmController,
                      controller: passwordConfirmController,
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
                          'authentication.register.sign_up'.tr(),
                          style: S.textStyles.button
                              .copyWith(color: S.colors.white),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref
                              .read(registerStateNotifierProvider.notifier)
                              .register(emailController.text,
                                  passwordController.text, nameController.text);
                          setState(() {
                            isLoading = true;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'authentication.register.register_2'.tr(),
                          style: S.textStyles.paragraph,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'authentication.register.register_3'.tr(),
                            style: S.textStyles.paragraph.copyWith(
                              color: S.colors.primary_3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
