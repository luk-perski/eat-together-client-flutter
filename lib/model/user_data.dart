import 'package:json_annotation/json_annotation.dart';

part 'UserData.g.dart';

@JsonSerializable()
class UserData {
  final int id;
  final String name;
  final String companyName;
  final String description;

  UserData({this.id, this.name, this.companyName, this.description});

//  factory UserData.fromJson(Map<String, dynamic> json) {
//    return UserData(
//        id: json['id'],
//        name: json['name'],
//        companyName: json['companyName'],
//        description: json['description']);
//  }
//
//  Map<String, String>
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
