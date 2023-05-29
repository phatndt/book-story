import 'package:book_story/core/enviroment/app_env.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_module.dart';
import 'core/const.dart';
import 'features/my_book_shelf/data/datasource/local/book_shelf_adapter.dart';
import 'features/my_book_shelf/data/model/book_shelf_model.dart';
import 'main.dart';

void main() async {
  AppEnvironment.setupEnv(Environment.dev);
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
  child: const MyApp(),
  ),
  ),
  );
}