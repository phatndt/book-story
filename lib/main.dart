import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/navigation/app_route.dart';
import 'core/colors/colors.dart';
import 'core/navigation/route_paths.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log("message");
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              errorColor: S.colors.red,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: S.colors.primary_3,
                secondary: S.colors.secondary_3,
              ),
              scaffoldBackgroundColor: S.colors.white,
            ),
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: RoutePaths.logIn,
          );
        }
    );
  }
}
