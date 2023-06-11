import 'package:book_story/core/navigation/route_paths.dart';
import 'package:book_story/core/widget/custom_elevated_button.dart';
import 'package:book_story/features/onboarding/di/on_boarding_module.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/colors/colors.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: S.size.length_50Vertical,
              ),
              Image.asset(
                'assets/logo/logo.png',
                scale: 1,
              ),
              SizedBox(
                height: S.size.length_50Vertical,
              ),
              Text(
                'wc_1'.tr(),
                style: S.textStyles.mediumTitle,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: S.size.length_50Vertical,
              ),
              Column(
                children: [
                  CustomElevatedButton(
                    child: Center(
                      child: Text(
                        'wc_2'.tr(),
                        style: S.textStyles.button,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, RoutePaths.logIn);
                      ref.watch(splashStateNotifierProvider.notifier).saveIsFirstTime();
                    },
                  ),
                  SizedBox(
                    height: S.size.length_20Vertical,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, RoutePaths.signUp);
                      ref.watch(splashStateNotifierProvider.notifier).saveIsFirstTime();
                    },
                    backgroundColor: S.colors.white,
                    child: Center(
                      child: Text(
                        'wc_3'.tr(),
                        style: S.textStyles.button
                            .copyWith(color: S.colors.primary_3),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: S.size.length_50Vertical,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
