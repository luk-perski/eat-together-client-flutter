import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwtapp/api_client/api_client.dart';
import 'package:jwtapp/main.dart';
import 'package:jwtapp/model/account_data.dart';
import 'package:jwtapp/model/add_account_data.dart';
import 'package:jwtapp/model/model.dart';
import 'package:jwtapp/utils/string_consts.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController companyController = new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
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
                      _buttonRegisterSection(),
                    ],
                  )
        )
    );
  }

  Container _headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
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
            controller: emailController,
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
          Divider(
            height: 50.0,
//            indent: 5.0,
            color: Colors.transparent,
          ),
//          SizedBox(height: 30.0),
          TextFormField(
            controller: nameController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              icon: Icon(
                Icons.account_box,
              ),
              hintText: "Name",
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

  Container _buttonRegisterSection() {
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
                _register();
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

  _register() async {
    var accountData = AccountData(
        email: emailController.text, password: passwordController.text);
    var userData = UserData(
        name: nameController.text,
        companyName: companyController.text,
        description: descriptionController.text);
    var data = new AddAccountData(accountData, userData);
    AccountApiClient().singUp(data).then((value) => {
          if (value)
            {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => MainPage()),
                  (Route<dynamic> route) => false)
            }
          else
            {
              //todo
            }
        });
  }
}
