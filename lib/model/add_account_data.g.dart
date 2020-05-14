// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_account_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddAccountData _$AddAccountDataFromJson(Map<String, dynamic> json) {
  return AddAccountData(
    json['accountData'] == null
        ? null
        : AccountData.fromJson(json['accountData'] as Map<String, dynamic>),
    json['userData'] == null
        ? null
        : UserData.fromJson(json['userData'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AddAccountDataToJson(AddAccountData instance) =>
    <String, dynamic>{
      'accountData': instance.accountData,
      'userData': instance.userData,
    };
