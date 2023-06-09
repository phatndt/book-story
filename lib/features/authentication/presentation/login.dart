import 'dart:io';

import 'package:book_story/core/navigation/route_paths.dart';
import 'package:book_story/core/widget/custom_elevated_button.dart';
import 'package:book_story/core/widget/snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/colors/colors.dart';
import '../../../core/presentation/state.dart';
import '../../../core/widget/custom_text_form_fill.dart';
import '../di/authentication_module.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late bool isShowClearIconEmailController;
  late bool isObscurePasswordController;
  late bool isShowClearIconPasswordController;
  late bool isLoading;
  late GlobalKey<FormState> _loginFormKey;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    isShowClearIconEmailController = false;
    isObscurePasswordController = true;
    isShowClearIconPasswordController = false;
    isLoading = false;
    _loginFormKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginStateNotifierProvider, (previous, next) {
      if (next is UISuccessState) {
        setState(() {
          isLoading = false;
        });
        if (next.data is bool) {
          if (next.data) {
            Navigator.pushNamedAndRemoveUntil(
                context, RoutePaths.main, (route) => false);
          }
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, RoutePaths.main, (route) => false);
        }
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
      child: WillPopScope(
        onWillPop: () async {
          exit(0);
        },
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _loginFormKey,
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
                        'authentication.login.welcome'.tr(),
                        style: S.textStyles.heading1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: S.colors.primary_3),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: S.size.length_40Vertical,
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
                            return 'authentication.login.please_enter_your_email'.tr();
                          } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'authentication.login.please_enter_valid_email'.tr();
                          }
                          return null;
                        },
                        hintText: 'authentication.login.email'.tr(),
                        obscureText: false,
                        inputType: TextInputType.emailAddress,
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        suffixIconData: isShowClearIconEmailController
                            ? IconButton(
                                splashColor: Colors.transparent,
                                icon: Icon(Icons.clear),
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
                        height: S.size.length_20Vertical,
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
                          if (value!.isEmpty) {
                            return 'authentication.login.please_enter_your_password'.tr();
                          }
                          return null;
                        },
                        hintText: 'authentication.login.password'.tr(),
                        obscureText: isObscurePasswordController,
                        controller: passwordController,
                        textInputAction: TextInputAction.done,
                        suffixIconData: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            isShowClearIconPasswordController
                                ? InkWell(
                                    child: const Icon(Icons.clear),
                                    onTap: () {
                                      passwordController.clear();
                                      setState(() {
                                        isShowClearIconPasswordController =
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
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePaths.forgot);
                        },
                        child: Text(
                          'authentication.login.forgot_password'.tr(),
                          style: S.textStyles.paragraph.copyWith(
                            fontWeight: FontWeight.w700,
                            color: S.colors.primary_3,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      CustomElevatedButton(
                        child: Center(
                          child: Text(
                            'authentication.login.login'.tr(),
                            style: S.textStyles.button
                                .copyWith(color: S.colors.white),
                          ),
                        ),
                        onPressed: () {
                          if (_loginFormKey.currentState!.validate()) {
                            ref.read(loginStateNotifierProvider.notifier).login(
                                emailController.text, passwordController.text);
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
                            'authentication.login.not_a_member'.tr(),
                            style: S.textStyles.paragraph,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, RoutePaths.signUp);
                            },
                            child: Text(
                              'authentication.login.register_now'.tr(),
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
      ),
    );
  }
}
