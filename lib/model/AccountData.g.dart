// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountData _$AccountDataFromJson(Map<String, dynamic> json) {
  return AccountData(
    id: json['id'] as int,
    eventHistory: json['eventHistory'] as String,
    password: json['password'] as String,
    email: json['email'] as String,
    userGroups: json['userGroups'] as String,
  );
}

Map<String, dynamic> _$AccountDataToJson(AccountData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventHistory': instance.eventHistory,
      'password': instance.password,
      'email': instance.email,
      'userGroups': instance.userGroups,
    };
