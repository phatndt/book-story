import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharePreferencesService {
  late SharedPreferences share;

  SharePreferencesService();

  init() async {
    log("1");
    share = await SharedPreferences.getInstance();
  }

  Future<bool?> getIsFirstTimeApp() async {
    share = await SharedPreferences.getInstance();
    return share.getBool("isFirstTime");
  }

  Future<bool> setIsFirstTimeApp() async {
    share = await SharedPreferences.getInstance();
    return await share.setBool("isFirstTime", false);
  }
}
