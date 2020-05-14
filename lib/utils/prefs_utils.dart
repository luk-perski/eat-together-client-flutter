import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
const String mobileTokenKey = "token";
const String accountIdKey = "accountId";
const String userIdKey = "userId";
const String firstNameKey = "firstName";
const String lastNameKey = "lastName";
const String companyKey = "companyName";

Future<bool> setStringValue(String key, String value) async {
  var prefs = await _prefs;
  return await prefs.setString(key, value);
}

Future<String> getStringValue(String key) async {
  var prefs = await _prefs;
  return prefs.getString(key) ?? '';
}

setIntValue(String key, int value) async {
  var prefs = await _prefs;
  prefs.setInt(key, value);
}

Future<int> getIntValue(String key) async {
  var prefs = await _prefs;
  return prefs.getInt(key) ?? -1;
}
