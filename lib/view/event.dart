import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:eat_together/model/event_data.dart';
import 'package:eat_together/model/model.dart';
import 'package:eat_together/repository/event_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventPage extends StatefulWidget {
  final EventData eventData;

  const EventPage({Key key, this.eventData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventPage(eventData);
}

class _EventPage extends State<EventPage> {
  final EventData _eventData;
  bool _isEditable = false;
  bool _isLoading = false;
  final TextEditingController _dateController = new TextEditingController();
  final TextEditingController _placeNameController =
      new TextEditingController();
  final TextEditingController _placeLocationController =
      new TextEditingController();
  final TextEditingController _descriptionController =
      new TextEditingController();
  final TextEditingController _participantsController =
      new TextEditingController();
  DateTime _eventDate;
  final _format = DateFormat("yyyy-MM-dd HH:mm");
  String _headerText;
  String _appBarText;
  bool _callerJoin = false;
  bool _callerIsCreator = false;

  _EventPage(this._eventData) {
    if (_eventData != null) {
      _placeNameController.text = _eventData.placeName;
      _dateController.text = _format.format(_eventData.date);
      _placeLocationController.text = _eventData.placeLocation;
      _descriptionController.text = _eventData.description;
      _participantsController.text = _eventData.participants;
      _headerText = "Going to the\n${_eventData.placeName}";
      _appBarText = "Event";
      _callerJoin = _eventData.callerJoin;
      _callerIsCreator = _eventData.callerIsCreator;
    } else {
      _isEditable = true;
      _headerText = "Where do you want to go?";
      _appBarText = "Add event";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarText),
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
                    _isEditable ? _buttonAddSection() : _buttonEventSection(),
                  ],
                )),
    );
  }

  Container _headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text(_headerText,
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

  Container _buttonEventSection() {
    String buttonText = "";
    var onPressedFunction;
    if (!_callerJoin) {
      buttonText = "Join";
      onPressedFunction = () => _joinToEvent();
    } else if (_callerIsCreator) {
      buttonText = "Delete";
      onPressedFunction = () => _deactivateFromEvent();
    } else {
      buttonText = "Left";
      onPressedFunction = () => _leftFromEvent();
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          onPressedFunction();
        },
        color: _callerJoin ? Colors.redAccent : Colors.lightGreen,
        child: Text(
          buttonText,
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
            enabled: _isEditable,
            format: _format,
            controller: _dateController,
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
            enabled: _isEditable,
            controller: _placeNameController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(
                Icons.local_dining,
              ),
              hintText: "Place name",
            ),
          ),
          TextFormField(
            enabled: _isEditable,
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
            enabled: _isEditable,
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
          ),
          !_isEditable
              ? TextFormField(
                  enabled: false,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _participantsController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.people,
                    ),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                )
              : new Container(),
        ]));
  }

  _addEvent() async {
    var eventData = EventData(
        date: DateTime.now(),
        placeName: _placeNameController.text,
        placeLocation: _placeLocationController.text,
        description: _descriptionController.text,
        locationLongitude: 52.408756,
        locationLatitude: 16.920957
//        creatorAccountId: await prefs.getIntValue(prefs.accountIdKey),
//        creatorName: "$firstName $lastName ($company)")
        );
    if (await EventRepository().addEvent(eventData)) {
      setState(() {
        _isLoading = false;
        Navigator.pop(context, "Event added.");
      });
    }
  }

  //todo zwracanie info, że dodane
  _joinToEvent() async {
    String response = await EventRepository().jointToEvent(_eventData.id);
    _returnToMain(response);
  }

  _leftFromEvent() async {
    String response = await EventRepository().leftFromEvent(_eventData.id);
    _returnToMain(response);
  }

  _deactivateFromEvent() async {
    String response = await EventRepository().deactivateEvent(_eventData.id);
    _returnToMain(response);
  }

  _returnToMain(String response) {
    Navigator.pop(context, response);
  }
}
