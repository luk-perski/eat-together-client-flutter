import 'package:eat_together/model/account_data.dart';
import 'package:eat_together/repository/account_repository.dart';
import 'package:eat_together/view/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';
import '../utils/api_utils.dart';
import '../utils/string_consts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
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
        onPressed: emailController.text == "" || passwordController.text == ""
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
          builder: (BuildContext context) => RegisterPage(),
        )),
        child: Text(
          "Don't have an account?",
        ),
//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
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
            controller: passwordController,
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
    //todo add image to header
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
        email: emailController.text, password: passwordController.text);
    var result = await AccountRepository().signIn(accountData);
    setState(() {
      _isLoading = false;
    });
    if (result) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MainPage()),
          (Route<dynamic> route) => false);
    } else {
      showError(context, "Login failed.");
    }
  }
}
