import 'package:eat_together/model/model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_account_data.g.dart';

@JsonSerializable()
class AddAccountData {
  final AccountData accountData;
  final UserData userData;

  AddAccountData(this.accountData, this.userData);

  factory AddAccountData.fromJson(Map<String, dynamic> json) =>
      _$AddAccountDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddAccountDataToJson(this);
}
