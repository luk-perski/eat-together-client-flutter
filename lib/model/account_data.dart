import 'package:json_annotation/json_annotation.dart';

part 'account_data.g.dart';

@JsonSerializable()
class AccountData {
  final int id;
  final String eventHistory;
  final String password;
  final String email;
  final String userGroups;

  AccountData(
      {this.id, this.eventHistory, this.password, this.email, this.userGroups});

  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDataToJson(this);

  @override
  String toString() {
    return 'AccountData{id: $id, eventHistory: $eventHistory, password: $password, email: $email, userGroups: $userGroups}';
  }
}
