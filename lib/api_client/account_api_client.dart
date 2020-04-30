import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/model.dart';
import '../utils/api_utils.dart' as api;

class AccountApiClient {
  static const String _urlBase = "http://192.168.1.16:2501";
  static const String _serverApi = "/api/v1/";
  static const String _serviceLoginName = "login";
  static const String _serviceRegisterName = "accounts/sign-up";

  Future<bool> signIn(String email, String password) async {
    Map data = <String, String>{
      "email": email,
      "password": password,
    };
    final response = await http
        .post(_urlBase + _serverApi + _serviceLoginName,
            body: json.encode(data), headers: await api.getHeaders())
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == HttpStatus.ok) {
      await api.setMobileToken(response.headers['authorization']);
      return true;
    }
    return false;
  }

  Future<bool> singUp(AddAccountData addAccountData) async {
    Map data = <String, dynamic>{
      "accountData": {
        "password": addAccountData.accountData.password,
        "email": addAccountData.accountData.email
      },
      "userData": {"name": addAccountData.userData.name}
    };
    final response = await http
        .post(_urlBase + _serverApi + _serviceRegisterName,
            body: json.encode(data), headers: await api.getHeaders())
        .timeout(const Duration(seconds: 10));
    print(response.body);
    if (response.statusCode == HttpStatus.created &&
        await signIn(addAccountData.accountData.email,
            addAccountData.accountData.password)) {
      return true;
    }
    return false;
  }
}
