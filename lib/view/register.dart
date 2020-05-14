import 'package:eat_together/main.dart';
import 'package:eat_together/model/account_data.dart';
import 'package:eat_together/model/add_account_data.dart';
import 'package:eat_together/model/model.dart';
import 'package:eat_together/repository/account_repository.dart';
import 'package:eat_together/utils/string_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController emailControllerRegister =
      new TextEditingController();
  final TextEditingController passwordControllerRegister =
      new TextEditingController();
  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController companyController = new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body:
            Center(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(20.0),
                        children: <Widget>[
                          _headerSection(),
                          _textSection(),
                          _buttonRegisterSection(context),
                        ],
                      )));
  }

  Container _headerSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text(app_name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
    );
  }

  Container _textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailControllerRegister,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(
                Icons.email,
              ),
              hintText: "Email",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
            ),
          ),
          TextFormField(
            controller: passwordControllerRegister,
            cursorColor: Colors.black,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock,
              ),
              hintText: "Password",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
            ),
          ),
          Divider(
            height: 50.0,
//            indent: 5.0,
            color: Colors.transparent,
          ),
//          SizedBox(height: 30.0),
          TextFormField(
            controller: firstNameController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(
                Icons.account_box,
              ),
              hintText: "First Name",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
            ),
          ),
          TextFormField(
            controller: lastNameController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(
                Icons.account_box,
              ),
              hintText: "Last Name",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
            ),
          ),
          TextFormField(
            controller: companyController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(
                Icons.domain,
              ),
              hintText: "Company",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
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
              hintText: "Some word about you...",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
            ),
          )
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
        onPressed: emailControllerRegister.text == "" ||
                passwordControllerRegister.text == ""
            ? null
            : () {
                setState(() {
                  _isLoading = true;
                });
                _register(context);
              },
        elevation: 0.0,
        color: Theme.of(context).accentColor,
        child: Text(
          "Sign Up",
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  _register(BuildContext context) async {
    var accountData = AccountData(
        email: emailControllerRegister.text,
        password: passwordControllerRegister.text);
    var userData = UserData(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        companyName: companyController.text,
        description: descriptionController.text);
    var data = new AddAccountData(accountData, userData);
    var result = await AccountRepository().signUp(data);
    setState(() {
      _isLoading = false;
    });
    if (result) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MainPage()),
          (Route<dynamic> route) => false);
    } else {
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: Text("Login failed."),
        ),
      );
    }
  }
}
