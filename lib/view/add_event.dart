import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:eat_together/model/event_data.dart';
import 'package:eat_together/model/model.dart';
import 'package:eat_together/repository/event_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/prefs_utils.dart' as prefs;

class AddEventPage extends StatefulWidget {
  final EventData eventData;

  const AddEventPage({Key key, this.eventData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddEventPage();
}

class _AddEventPage extends State<AddEventPage> {
  bool _isLoading = false;
  final TextEditingController _dateController = new TextEditingController();
  final TextEditingController _placeNameController =
      new TextEditingController();
  final TextEditingController _placeLocationController =
      new TextEditingController();
  final TextEditingController _descriptionController =
      new TextEditingController();
  DateTime _eventDate;
  final _format = DateFormat("yyyy-MM-dd HH:mm");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add event'),
      ),
      body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20.0),
                  children: <Widget>[
                    _headerSection(),
                    _textSection(),
                    _buttonAddSection(),
                  ],
                )),
    );
  }

  Container _headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Where do you want to go?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
    );
  }

  Container _buttonAddSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: _placeNameController.text == "" || _eventDate == null
            ? null
            : () {
                setState(() {
                  _isLoading = true;
                });
                _addEvent();
              },
        color: Theme.of(context).accentColor,
        child: Text(
          "Add",
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  Container _textSection() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(children: <Widget>[
          DateTimeField(
            format: _format,
            decoration: InputDecoration(
              icon: Icon(
                Icons.date_range,
              ),
              hintText: "Event date",
            ),
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                _eventDate = DateTimeField.combine(date, time);
                return _eventDate;
              } else {
                return currentValue;
              }
            },
          ),
          TextFormField(
            controller: _placeNameController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(
                Icons.local_dining,
              ),
              hintText: "Place name",
            ),
          ),
          //todo change to  location search dialog
          TextFormField(
            controller: _placeLocationController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(
                Icons.location_on,
              ),
              hintText: "Location",
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: _descriptionController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(
                Icons.chat,
              ),
              hintText: "Some word about event...",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
            ),
          )
        ]));
  }

  _addEvent() async {
    var firstName = await prefs.getStringValue(prefs.firstNameKey);
    var lastName = await prefs.getStringValue(prefs.lastNameKey);
    var company = await prefs.getStringValue(prefs.companyKey);
    var eventData = EventData(
        date: _eventDate,
        placeName: _placeNameController.text,
        placeLocation: _placeLocationController.text,
        description: _descriptionController.text,
//        creatorAccountId: await prefs.getIntValue(prefs.accountIdKey), // to chyba już niepotrzebne
//        creatorName: "$firstName $lastName ($company)"
    );
    if (await EventRepository().addEvent(eventData)) {
      setState(() {
        _isLoading = false;
        Navigator.pop(context);
      });
    }
  }
}
