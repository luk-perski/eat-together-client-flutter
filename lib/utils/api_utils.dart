import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import './prefs_utils.dart' as prefs;

const String urlBase = "http://10.0.2.2:2501";
const String serverApi = "/api/v1/";

Future<String> _getMobileToken() async {
  return await prefs.getStringValue(prefs.mobileTokenKey);
}

Future<bool> setMobileToken(String token) async {
  return prefs.setStringValue(prefs.mobileTokenKey, token);
}

setAccountUserData(int accountId, int userId, String firstName, String lastName,
    String company) async {
  await prefs.setIntValue(prefs.accountIdKey, accountId);
  await prefs.setIntValue(prefs.userIdKey, userId);
  await prefs.setStringValue(prefs.firstNameKey, firstName);
  await prefs.setStringValue(prefs.lastNameKey, lastName);
  await prefs.setStringValue(prefs.companyKey, company);
}

Future<Map<String, String>> getHeaders() async {
  return {
    'Authorization': await _getMobileToken(),
    'Content-Type': 'application/json'
  };
}

showError(BuildContext context, String errorMsg) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMsg),
    ),
  );
}

String getUtf8Body(Response response){
  return  Utf8Decoder().convert(response.bodyBytes);
}
