import 'package:eat_together/model/event_data.dart';
import 'package:eat_together/repository/event_repository.dart';
import 'package:eat_together/utils/string_consts.dart';
import 'package:eat_together/utils/widget_utils.dart';
import 'package:eat_together/view/event.dart';
import 'package:eat_together/view/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Eat together",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(accentColor: Colors.blue),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if (_sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(app_name, style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.refresh), onPressed: _refresh),
          new IconButton(
              icon: new Icon(Icons.settings),
              onPressed: () {
                goToUserScreen(context);
              }),
          FlatButton(
            onPressed: () {
              _sharedPreferences.clear();
//              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(
          child: FutureBuilder<List<EventData>>(
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
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .push(new MaterialPageRoute(
                  builder: (BuildContext context) => EventPage()))
              .whenComplete(() => _refresh());
        },
        icon: Icon(Icons.add),
        label: Text("Add event"),
      ),
    );
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
              eventDate, format, data[index]);
        });
  }

  Card _event(String placeName, String creatorName, DateTime date,
          String format, EventData data) =>
      Card(
          child: ListTile(
              title: Text("$placeName (${DateFormat(format).format(date)})",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  )),
              subtitle: Text("Added by $creatorName"),
              leading: new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(
                    child: new Text(DateFormat(DateFormat.WEEKDAY)
                        .format(date)
                        .substring(0, 2))),
              ),
              onTap: () {
                goToEventScreen(context, data);
              }));

  goToEventScreen(BuildContext context, EventData data) async {
    final response = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => EventPage(
                  eventData: data,
                )));
    showSnackBar(_scaffoldKey, response, 2);
    _refresh();
  }

  goToUserScreen(
    BuildContext context,
  ) async {
    final response = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => UserPage(
                  isRegister: false,
                )));
  }

  Future<List<EventData>> _fetchEvents() async {
    var events = await EventRepository().getCurrentEvents();
    showSnackBar(_scaffoldKey, "Events updated.");
    return events;
  }

  void _refresh() {
    setState(() {});
  }
}
