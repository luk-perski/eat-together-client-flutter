import 'package:json_annotation/json_annotation.dart';

part 'event_data.g.dart';

@JsonSerializable()
class EventData {
  final int id;
  final int creatorAccountId;
  final DateTime date;
  final String placeName;
  final String placeLocation;
  final String description;
  final String creatorName;
  final bool callerJoin;
  final bool callerIsCreator;
  final double locationLongitude;
  final double locationLatitude;
  final String participants;

  EventData(
      {this.id,
      this.description,
      this.creatorAccountId,
      this.date,
      this.placeName,
      this.placeLocation,
      this.creatorName,
      this.callerJoin,
      this.callerIsCreator,
      this.locationLongitude,
      this.locationLatitude,
      this.participants});

  factory EventData.fromJson(Map<String, dynamic> json) =>
      _$EventDataFromJson(json);

  Map<String, dynamic> toJson() => _$EventDataToJson(this);
}
