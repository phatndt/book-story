import 'package:book_story/core/widget/custom_elevated_button.dart';
import 'package:book_story/features/authentication/di/authentication_module.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/colors/colors.dart';
import '../../../core/presentation/state.dart';
import '../../../core/widget/custom_text_form_fill.dart';
import '../../../core/widget/snack_bar.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  late TextEditingController emailController;
  late bool isShowClearIconEmailController;
  late bool isLoading;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    emailController = TextEditingController();
    isShowClearIconEmailController = false;
    isLoading = false;
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(forgotPasswordStateNotifierProvider, (previous, next) {
      if (next is UISuccessState) {
        setState(() {
          isLoading = false;
        });
        final snackBar = SuccessSnackBar(
          message: 'authentication.forgot_password.reset_password_successfully'.tr(),
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
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: S.size.length_40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: S.size.length_40Vertical,
                    ),
                    Image.asset(
                      'assets/logo/logo_other.png',
                      scale: 1,
                    ),
                    SizedBox(
                      height: S.size.length_40Vertical,
                    ),
                    Text(
                      'authentication.forgot_password.forgot_password_1'.tr(),
                      style: S.textStyles.heading1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: S.colors.primary_3),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      'authentication.forgot_password.forgot_password_2'.tr(),
                      style: S.textStyles.paragraph,
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
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'authentication.login.please_enter_valid_email'.tr();
                        }
                        return null;
                      },
                      hintText: 'authentication.login.email'.tr(),
                      obscureText: false,
                      controller: emailController,
                      textInputAction: TextInputAction.done,
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
                      height: 24.h,
                    ),
                    CustomElevatedButton(
                      child: Center(
                        child: Text(
                          'authentication.forgot_password.confirm'.tr(),
                          style: S.textStyles.button
                              .copyWith(color: S.colors.white),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          ref
                              .read(
                                  forgotPasswordStateNotifierProvider.notifier)
                              .resetPassword(emailController.text);
                        }
                      },
                    )
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
