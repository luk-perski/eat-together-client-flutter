import 'dart:convert';
import 'dart:io';

import 'package:eat_together/model/model.dart';
import 'package:http/http.dart';

import '../api_client/api_client.dart' as api;
import '../utils/api_utils.dart' as apiUtils;

class AccountRepository {
  static const String _serviceLoginName = "login";
  static const String _serviceRegisterName = "accounts/sign-up";

  Future<bool> signIn(AccountData userData) async {
    Response response =
        await api.ApiClient().post(userData.toJson(), _serviceLoginName);
    if (response.statusCode == HttpStatus.ok) {
      return await apiUtils.setMobileToken(response.headers['authorization']);
    }
    return false;
  }

  Future<bool> signUp(AddAccountData addAccountData) async {
    Response response = await api.ApiClient()
        .post(addAccountData.toJson(), _serviceRegisterName);
    if (response.statusCode == HttpStatus.created) {
      final Map body = json.decode(response.body);
      final data = AddAccountData.fromJson(body);
      apiUtils.setAccountUserData(
          data.accountData.id,
          data.userData.id,
          data.userData.firstName,
          data.userData.lastName,
          data.userData.companyName);
      return await signIn(addAccountData.accountData);
    }
    return false;
  }
}
