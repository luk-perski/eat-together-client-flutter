// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventData _$EventDataFromJson(Map<String, dynamic> json) {
  return EventData(
    id: json['id'] as int,
    description: json['description'] as String,
    creatorAccountId: json['creatorAccountId'] as int,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    placeName: json['placeName'] as String,
    placeLocation: json['placeLocation'] as String,
    creatorName: json['creatorName'] as String,
  );
}

Map<String, dynamic> _$EventDataToJson(EventData instance) => <String, dynamic>{
      'id': instance.id,
      'creatorAccountId': instance.creatorAccountId,
      'date': instance.date?.toIso8601String(),
      'placeName': instance.placeName,
      'placeLocation': instance.placeLocation,
      'description': instance.description,
      'creatorName': instance.creatorName,
    };
