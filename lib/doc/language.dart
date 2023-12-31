import 'package:shared_preferences/shared_preferences.dart';

class Asset {
  Future<Map<String, String>> get lang async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt('lang') ?? 1;

    return value == 1
        ? ({
            'login': 'login',
            'email': 'email or username',
            'pass': 'password',
            'signin': 'sign in',
            'iflogin': 'click if you have account',
            'ifnotlogin': 'click if you dont have account'
          })
        : ({});
  }
}
