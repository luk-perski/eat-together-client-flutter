import 'dart:async';

import 'package:eat_together/model/event_data.dart';
import 'package:eat_together/repository/event_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventData>>(
      future: _fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<EventData> data = snapshot.data;
          return _eventsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}

ListView _eventsListView(List<EventData> data) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final now = DateTime.now();
        final eventDate = data[index].date;
        String format;
        if (DateTime(now.year, now.month, now.day) ==
            DateTime(eventDate.year, eventDate.month, eventDate.day)) {
          format = DateFormat.HOUR24_MINUTE;
        } else {
          format = DateFormat.MONTH_WEEKDAY_DAY;
        }
        return _event(data[index].placeName, data[index].creatorName,
            eventDate, format);
      });
}

ListTile _event(String placeName, String creatorName, DateTime date, String format) => ListTile(
      title: Text("$placeName (${DateFormat(format).format(date)})",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text("Added by $creatorName"),
      leading: new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(
            child: new Text(DateFormat(DateFormat.WEEKDAY).format(date).substring(0,2))),
      ),
    );

Future<List<EventData>> _fetchEvents() async {
  return await EventRepository().getCurrentEvents();
}
