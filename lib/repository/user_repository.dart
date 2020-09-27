import 'dart:convert';

import 'package:eat_together/model/model.dart';

import '../api_client/api_client.dart' as api;
import '../utils/api_utils.dart' as apiUtils;

class UserRepository {
  static const String _serviceUserByEmailName = "users/account";
  static const String _serviceUpdateUserName = "users";

  Future<UserData> getUserByEmail() async {
    var response = await api.ApiClient().get(_serviceUserByEmailName);
    return UserData.fromJson(json.decode(apiUtils.getUtf8Body(response)));
  }

  Future<UserData> updateUser(UserData data) async {
    var response =
        await api.ApiClient().patch(data.toJson(), _serviceUpdateUserName);
    return UserData.fromJson(json.decode(apiUtils.getUtf8Body(response)));
  }
}
