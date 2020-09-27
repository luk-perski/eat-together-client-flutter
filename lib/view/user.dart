import 'package:eat_together/model/account_data.dart';
import 'package:eat_together/model/add_account_data.dart';
import 'package:eat_together/model/model.dart';
import 'package:eat_together/repository/account_repository.dart';
import 'package:eat_together/repository/user_repository.dart';
import 'package:eat_together/utils/string_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'file:///C:/Dane/aaaStudia/mgr_Perski/flutter-nauka/eat-together-client-flutter/lib/main.dart';

import '../utils/widget_utils.dart';

class UserPage extends StatefulWidget {
  final bool isRegister;

  @override
  _UserPageState createState() => _UserPageState(isRegister);

  const UserPage({Key key, this.isRegister});
}

class _UserPageState extends State<UserPage> {
  final Geolocator _geolocator = Geolocator()..forceAndroidLocationManager;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _emailControllerRegister =
      new TextEditingController();
  final TextEditingController _passwordControllerRegister =
      new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  final TextEditingController _lastNameController = new TextEditingController();
  final TextEditingController _companyController = new TextEditingController();
  final TextEditingController _descriptionController =
      new TextEditingController();
  final TextEditingController _locationController = new TextEditingController();

  UserData _initUserData;
  bool _isLoading = false;
  bool _isRegister;
  bool _initUpdateButton = true;
  bool _isLocationFound = true;
  String _locationName;
  Position _location;
  double _dropDownValue = 1;

  _UserPageState(bool isRegister) {
    _isRegister = isRegister;
  }

  @override
  void initState() {
    _getAddressFromLatLng();
    if (!_isRegister) {
      _fetchUserData().then(
        (value) => {
          _firstNameController.text = value.firstName,
          _lastNameController.text = value.lastName,
          _companyController.text = value.companyName,
          _descriptionController.text = _descriptionController.text.isNotEmpty
              ? value.description
              : "Add description...",
          _locationController.text = value.userLocationAddress,
          _initUserData = value,
          _initUpdateButton = true,
          _dropDownValue = value.distanceRange
        },
//          onError: () {
//        //todo
//      }
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_isRegister ? 'Register' : "User"),
        ),
        body: Center(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20.0),
                    children: <Widget>[
                      _headerSection(),
                      _isRegister ? _credentialsSection() : Container(),
                      _isRegister
                          ? _textSection()
                          : _textSection(_initUserData),
                      _buttonRegisterSection(context),
                    ],
                  )));
  }

  Container _headerSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text(_isRegister ? app_name : "Edit your account info",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
    );
  }

  Container _textSection([UserData data]) {
    return Container(
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _firstNameController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(
                Icons.account_box,
              ),
              hintText: "First Name",
            ),
          ),
          TextFormField(
            controller: _lastNameController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(
                Icons.account_box,
              ),
              hintText: "Last Name",
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: TextFormField(
                controller: _locationController,
                enabled: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    icon: Icon(Icons.location_on),
                    hintText: !_isLocationFound
                        ? "Use the right button to locate you"
                        : _locationName),
              )),
//              Expanded(child:
              IconButton(
                icon: !_isLocationFound
                    ? Icon(Icons.location_searching)
                    : Icon(Icons.my_location),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  _getCurrentLocation();
                },
              ),
//              )
            ],
          ),
          Row(children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(right: 16),
              child: Icon(
                Icons.map,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: DropdownButton<double>(
                value: _dropDownValue,
                iconSize: 24,
                isExpanded: true,
                elevation: 16,
                underline: Container(
                  height: 2,
                  color: Theme.of(context).accentColor,
                ),
                onChanged: (double newValue) {
                  setState(() {
                    _dropDownValue = newValue;
                  });
                },
                items: <double>[0.2, 0.5, 1, 1.5, 2, 2.5, 3]
                    .map<DropdownMenuItem<double>>((double value) {
                  return DropdownMenuItem<double>(
                    value: value,
                    child:
                        Text("Places distance range: ${value.toString()} km"),
                  );
                }).toList(),
              ),
            ),
          ]),
          TextFormField(
            controller: _companyController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(
                Icons.domain,
              ),
              hintText: "Company",
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
              hintText: "Some word about you...",
            ),
          )
        ],
      ),
    );
  }

  Container _credentialsSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _emailControllerRegister,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(
                Icons.email,
              ),
              hintText: "Email",
            ),
          ),
          TextFormField(
            controller: _passwordControllerRegister,
            cursorColor: Colors.black,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock,
              ),
              hintText: "Password",
            ),
          ),
          Divider(
            height: 40.0,
//            indent: 5.0,
            color: Colors.transparent,
          ),
//          SizedBox(height: 30.0),
        ],
      ),
    );
  }

  Container _buttonRegisterSection(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed:
            _isRegister ? onUserRegisterPressed() : onUserUpdatePressed(),
        elevation: 0.0,
        color: Theme.of(context).accentColor,
        child: Text(
          _isRegister ? "Sign Up" : "Update",
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  _register(BuildContext context) async {
    var accountData = AccountData(
        email: _emailControllerRegister.text,
        password: _passwordControllerRegister.text);
    var data = new AddAccountData(accountData, _getUserData());
    var result = await AccountRepository().signUp(data);
    setState(() {
      _isLoading = false;
    });
    if (result) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MainPage()),
          (Route<dynamic> route) => false);
    } else {
      showSnackBar(_scaffoldKey, "Login failed.", 3);
    }
  }

  Future<UserData> _fetchUserData() async {
    return await UserRepository().getUserByEmail();
  }

  Function onUserRegisterPressed() {
    if (_emailControllerRegister.text == "" ||
        _passwordControllerRegister.text == "" ||
        _firstNameController.text == "" ||
        _companyController.text == "" ||
        _location == null ||
        _locationName.isEmpty) {
      return null;
    } else {
      return () {
        setState(() {
          _isLoading = true;
        });
        _register(context);
      };
    }
  }

  Function onUserUpdatePressed() {
    if (_initUpdateButton &&
        _location != null &&
        (_firstNameController.text != _initUserData.firstName ||
            _lastNameController.text != _initUserData.lastName ||
            _companyController.text != _initUserData.companyName ||
            _descriptionController.text != _initUserData.description ||
            _location.latitude != _initUserData.userLocationLatitude ||
            _location.longitude != _initUserData.userLocationLongitude ||
            (_firstNameController.text.isNotEmpty &&
                _initUserData.firstName.isEmpty) ||
            (_descriptionController.text.isNotEmpty &&
                    _initUserData.description.isEmpty) &&
                _locationName.isNotEmpty)) {
      return () async {
        await UserRepository().updateUser(_getUserData());
        Navigator.pop(context);
      };
    } else {
      return null; //todo
    }
  }

  UserData _getUserData() {
    return UserData(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        companyName: _companyController.text,
        description: _descriptionController.text,
        userLocationLatitude: 52.409528,
        userLocationLongitude: 52.409528,
        userLocationAddress: _locationName,
        distanceRange: _dropDownValue);
  }

  _getCurrentLocation() {
    _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _location = position;
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          _location.latitude, _location.longitude);
//      List<Placemark> p =
//          await _geolocator.placemarkFromCoordinates(52.409528, 16.912463);
      Placemark place = p[0];
      setState(() {
        _locationName =
            "${place.thoroughfare} ${place.subThoroughfare}, ${place.subLocality}, ${place.locality}";
        _isLocationFound = true;
      });
    } catch (e) {
      print(e);
    }
  }
}
