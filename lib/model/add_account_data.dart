import 'package:json_annotation/json_annotation.dart';
import 'package:jwtapp/model/account_data.dart';
import 'package:jwtapp/model/model.dart';

part 'AddAccountData.g.dart';

@JsonSerializable()
class AddAccountData {
  final AccountData accountData;
  final UserData userData;

  AddAccountData(this.accountData, this.userData);

  factory AddAccountData.fromJson(Map<String, dynamic> json) =>
      _$AddAccountDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddAccountDataToJson(this);
}
