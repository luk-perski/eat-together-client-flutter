import 'dart:io';

import 'package:eat_together/model/event_data.dart';
import 'package:query_params/query_params.dart';

import '../api_client/api_client.dart' as api;

class EventRepository {
  static const String _serviceEventName = "events";
  static const String _serviceEventCurrentName = "events/current";
  static const String _serviceJoinToEventName = "events/join";
  static const String _serviceLeftFromEventName = "events/left";
  static const String _deactivateEventName = "events/deactivate";

  Future<bool> addEvent(EventData eventData) async {
    var response =
        await api.ApiClient().post(eventData.toJson(), _serviceEventName);
    print(response.body.toString());
    return response.statusCode == HttpStatus.ok;
  }

  Future<List<EventData>> getCurrentEvents() async {
    var body = await api.ApiClient().getList(_serviceEventCurrentName);
    return body.map((event) => new EventData.fromJson(event)).toList();
  }

  Future<String> jointToEvent(int eventId) async {
    var response = await api.ApiClient()
        .put(_serviceJoinToEventName + getEventIdReqParam(eventId));
    var x = response.body.toString();
    return x;
  }

  Future<String> leftFromEvent(int eventId) async {
    var response = await api.ApiClient()
        .delete(_serviceLeftFromEventName + getEventIdReqParam(eventId));
    return response.body;
  }

  Future<String> deactivateEvent(int eventId) async {
    var response = await api.ApiClient()
        .delete(_deactivateEventName + getEventIdReqParam(eventId));
    return response.body;
  }

  String getEventIdReqParam(int eventId) {
    URLQueryParams queryParams = new URLQueryParams();
    queryParams.append("eventId", eventId);
    return "?${queryParams.toString()}";
  }
}
