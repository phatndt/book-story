import 'dart:developer';

import 'package:book_story/core/const.dart';
import 'package:book_story/features/my_book_shelf/data/model/book_shelf_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_module.dart';
import 'core/navigation/app_route.dart';
import 'core/colors/colors.dart';
import 'core/navigation/route_paths.dart';
import 'features/my_book_shelf/data/datasource/local/book_shelf_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BookShelfAdapter());
  await Hive.openBox<BookShelfModel>(bookShelf);
  final prefs = await SharedPreferences.getInstance();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale.fromSubtags(languageCode: 'en'),
        Locale.fromSubtags(languageCode: 'vi')
      ],
      path: 'assets/translations',
      child: ProviderScope(
        overrides: [
          sharePreferences.overrideWithValue(prefs),
        ],
        child: MyApp(),
      ),
    ),
  );
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
            initialRoute: RoutePaths.splash,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        });
  }
}
