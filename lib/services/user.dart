import 'dart:convert';

import 'package:Season/models/user/model_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();
  // passes the instantiation to the user object
  factory CurrentUser() => _instance;

  //initialize variables in here
  CurrentUser._internal() {
    user = null;
  }

  var user;
  Future<LoginResponse> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var currentEmail = prefs.getString('email') ?? "";
    if (currentEmail != "") {
      String currentUser = prefs.getString('user') ?? "";
      var jsonData = jsonDecode(currentUser);
      // print(jsonData);
      user = LoginResponse(jsonData["id"], jsonData["name"], jsonData["email"],
          jsonData["roles"], jsonData["roles_raw"], jsonData["permissions"]);
    }
    return user;
  }
}
