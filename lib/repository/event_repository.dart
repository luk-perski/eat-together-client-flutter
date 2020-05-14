import 'dart:io';

import 'package:eat_together/model/event_data.dart';

import '../api_client/api_client.dart' as api;

class EventRepository {
  static const String _serviceEventName = "events";
  static const String _serviceEventCurrentName = "events/current";

  Future<bool> addEvent(EventData eventData) async {
    var response =
        await api.ApiClient().post(eventData.toJson(), _serviceEventName);
    return response.statusCode == HttpStatus.ok;
  }

  Future<List<EventData>> getCurrentEvents() async {
    var body = await api.ApiClient().get(_serviceEventCurrentName);
    return body.map((event) => new EventData.fromJson(event)).toList();
  }
}
