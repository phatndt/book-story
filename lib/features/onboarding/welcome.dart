import 'package:book_story/core/navigation/route_paths.dart';
import 'package:book_story/core/widget/custom_elevated_button.dart';
import 'package:book_story/presentation/views/widgets/filled_button.dart';
import 'package:book_story/presentation/views/widgets/outline_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/colors/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                'Experience reading and sharing \nbooks like never before',
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
                        "Login now!",
                        style: S.textStyles.button,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, RoutePaths.logIn);
                    },
                  ),
                  SizedBox(
                    height: S.size.length_20Vertical,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, RoutePaths.signUp);
                    },
                    backgroundColor: S.colors.white,
                    child: Center(
                      child: Text(
                        "Register now!",
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
