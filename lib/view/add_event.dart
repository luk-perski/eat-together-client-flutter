import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddEventPage();
}

class _AddEventPage extends State<AddEventPage> {
  bool _isLoading = false;
  final TextEditingController dateController = new TextEditingController();
  final TextEditingController placeNameController = new TextEditingController();
  final TextEditingController placeLocationController =
      new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();
  DateTime eventDate;
  final format = DateFormat("yyyy-MM-dd HH:mm");

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
        onPressed: placeNameController.text == "" || eventDate == null
            ? null
            : () {
                Navigator.pop(context);
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
            format: format,
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
                eventDate = DateTimeField.combine(date, time);
                return eventDate;
              } else {
                return currentValue;
              }
            },
          ),
          TextFormField(
            controller: placeNameController,
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
            controller: placeLocationController,
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
            controller: descriptionController,
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
}
