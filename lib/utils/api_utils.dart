import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
const String _storageKeyMobileToken = "token";

Future<String> _getMobileToken() async {
  final SharedPreferences prefs = await _prefs;
  return prefs.getString(_storageKeyMobileToken) ?? '';
}

Future<bool> setMobileToken(String token) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.setString(_storageKeyMobileToken, token);
}

Future<Map<String, String>> getHeaders() async {
  return {
    'Authorization': await _getMobileToken(),
    'Content-Type': 'application/json'
  };
}
