import 'package:flutter/material.dart';
import 'package:Season/services/api.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../homeBottomMenu.dart';
import '../models/user/model_user.dart';

class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyLoginPage> {
  _MyHomePageState();
  bool loading = false;
  var _passwordVisible;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      obscureText: false,
      style: style,
      controller: email,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail, color: Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      validator: (value) => EmailValidator.validate(value.toString())
          ? null
          : "Please enter a valid email",
    );
    final passwordField = TextFormField(
      obscureText: !_passwordVisible,
      style: style,
      controller: pass,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_open, color: Colors.grey),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password can\'t be empty';
        }
        return null;
      },
    );
    final loginButon = Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
          color: Color(0xFFF05A8CF), borderRadius: BorderRadius.circular(20)),
      child: TextButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
            _authentification(email.text, pass.text, context);
          }
        },
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );

    return Form(
      key: _formKey,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 155.0,
                      child: Image.asset(
                        "assets/images/season-intranet.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 45.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    loginButon,
                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      height: 130,
                    ),
                    Text(
                      'Season app by Mayem Solutions | v1.0.0',
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<LoginResponse> _getUserData(email, pass) async {
    ApiUrl url = new ApiUrl();
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    LoginResponse user = new LoginResponse(0, "", "", [], [], []);
    //var user;

    try {
      var data = await client.post(Uri.parse(apiUrl + 'auth/login'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'X-Authorization': apiKey,
          },
          body: jsonEncode(<String, String>{'email': email, 'password': pass}));
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        user = new LoginResponse(
            jsonData['id'],
            jsonData['name'],
            jsonData['email'],
            jsonData['roles'],
            jsonData['roles_raw'],
            jsonData['permissions']);
        print(user);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user', data.body);
        prefs.setString('email', jsonData["email"]);
        return user;
      } else {
        return user;
      }
    } catch (e) {
      client.close();
      print(e);
      return throw Exception(e);
    }
  }

  _authentification(email, pass, context) async {
    var response = await _getUserData(email, pass);
    if (response.email.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Error!!"),
              content: new Text("Email or password are incorrect!"),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.red, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              actions: <Widget>[
                new TextButton(
                  child: new Text("Try Again"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => MyHomePage(
      //               index: 0,
      //               //user: user,
      //             )));

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => HomeBottomMenu(
                    index: 0,
                  )));
    }
  }
}
