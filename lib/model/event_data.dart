import 'package:json_annotation/json_annotation.dart';

part 'event_data.g.dart';

@JsonSerializable()
class EventData {
  int id;
  final int creatorAccountId;
  final DateTime date;
  final String placeName;
  final String placeLocation;
  final String description;
  final String creatorName;

  EventData(
      {this.id,
      this.description,
      this.creatorAccountId,
      this.date,
      this.placeName,
      this.placeLocation,
      this.creatorName});

  factory EventData.fromJson(Map<String, dynamic> json) =>
      _$EventDataFromJson(json);

  Map<String, dynamic> toJson() => _$EventDataToJson(this);
}
