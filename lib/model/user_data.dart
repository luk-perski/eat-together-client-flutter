import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  final int id;
  final String firstName;
  final String lastName;
  final String companyName;
  final String description;

  UserData(
      {this.id,
      this.firstName,
      this.lastName,
      this.companyName,
      this.description});

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
