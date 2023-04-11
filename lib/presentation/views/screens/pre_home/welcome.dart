import 'package:book_exchange/core/route_paths.dart';
import 'package:book_exchange/presentation/views/widgets/filled_button.dart';
import 'package:book_exchange/presentation/views/widgets/outline_button.dart';
import 'package:flutter/material.dart';
import '../../../../../core/colors/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
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
                  CustomOutlineButton(
                    text: 'EXISTING USER',
                    onPress: () {
                      Navigator.pushReplacementNamed(context, RoutePaths.logIn);
                    },
                    width: S.size.length_280,
                  ),
                  SizedBox(
                    height: S.size.length_20Vertical,
                  ),
                  CustomFilledButton(
                    width: S.size.length_280,
                    text: 'NEW USER',
                    onPress: () {
                      Navigator.pushReplacementNamed(
                          context, RoutePaths.signUp);
                    },
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
