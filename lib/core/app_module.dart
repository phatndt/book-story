import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharePreferences = Provider<SharedPreferences>(
    (_) => throw UnimplementedError("sharedPrefs is not implemented"));
