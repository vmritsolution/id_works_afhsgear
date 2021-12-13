
import 'package:flutter_session/flutter_session.dart';

class SessionsUtility {
  late String userName;
  late String password;
  static bool loginStatus=false;

  SessionsUtility({required this.userName, required this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["userName"] = this.userName;
    data["password"] = this.password;
    return data;
  }

   static void setLoginStatus(bool val) {
     loginStatus = val;
   }

   static bool getLoginStatus() {
     return loginStatus == null ? false : loginStatus;
   }

  void doUserLogout() async {
    // await FlutterSession().prefs.clear();
    FlutterSession prefs = FlutterSession();
    prefs.prefs.remove("myData");
    loginStatus=true;
  }
}