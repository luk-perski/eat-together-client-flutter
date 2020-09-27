// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    id: json['id'] as int,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    companyName: json['companyName'] as String,
    description: json['description'] as String,
    userLocationLongitude: (json['userLocationLongitude'] as num)?.toDouble(),
    userLocationLatitude: (json['userLocationLatitude'] as num)?.toDouble(),
    userLocationAddress: json['userLocationAddress'] as String,
    distanceRange: (json['distanceRange'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'companyName': instance.companyName,
      'description': instance.description,
      'userLocationLongitude': instance.userLocationLongitude,
      'userLocationLatitude': instance.userLocationLatitude,
      'userLocationAddress': instance.userLocationAddress,
      'distanceRange': instance.distanceRange,
    };
