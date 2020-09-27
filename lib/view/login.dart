import 'package:eat_together/model/account_data.dart';
import 'package:eat_together/repository/account_repository.dart';
import 'package:eat_together/view/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/string_consts.dart';
import '../utils/widget_utils.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Builder(builder: (BuildContext context) {
        return Center(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20.0),
                    children: <Widget>[
                      headerSection(),
                      textSection(),
                      buttonSignInSection(context),
                      buttonSignUpSection(),
                    ],
                  ));
      }),
    );
  }

  Container buttonSignInSection(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: _emailController.text == "" || _passwordController.text == ""
            ? null
            : () {
                setState(() {
                  _isLoading = true;
                });
                _signIn(context);
              },
        elevation: 0.0,
        color: Theme.of(context).accentColor,
        child: Text(
          "Sign In",
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  Container buttonSignUpSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: MaterialButton(
        onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => UserPage(
            isRegister: true,
          ),
        )),
        child: Text(
          "Don't have an account?",
        ),
      ),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _emailController,
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
          SizedBox(height: 30.0),
          TextFormField(
            controller: _passwordController,
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
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text(app_name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
    );
  }

  _signIn(BuildContext context) async {
    var accountData = AccountData(
        email: _emailController.text, password: _passwordController.text);
    var result = await AccountRepository().signIn(accountData);
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
}
