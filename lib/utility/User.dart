
class User {
  /*
  This class encapsulates the json response from the api
  {
      'userId': '1908789',
      'username': username,
      'name': 'Peter Clarke',
      'lastLogin': "23 March 2020 03:34 PM",
      'email': 'x7uytx@mundanecode.com'
  }
  */
  late String _userId;
  late String _username;
  late String _name;
  late String _lastLogin;
  late String _email;

  User(
      {required String userId,
      required String username,
  required String name,
      required String lastLogin,
  required String email}) {
this._userId = userId;
this._username = username;
this._name = name;
this._lastLogin = lastLogin;
this._email = email;
}

// Properties
String get userId => _userId;
set userId(String userId) => _userId = userId;
String get username => _username;
set username(String username) => _username = username;
String get name => _name;
set name(String name) => _name = name;
String get lastLogin => _lastLogin;
set lastLogin(String lastLogin) => _lastLogin = lastLogin;
String get email => _email;
set email(String email) => _email = email;

// {"status":"200","message":{"customerFirst":"Bramy","customerLast":"ado","customerEmail":"brahmy143@gmail.com","customerID":"118617","token":"e9af16c3-5d4c-11ec-9753-00259099300e"}}
// create the user object from json input

User.fromJson(Map<String, dynamic> json) {
_userId = json['customerFirst'];
_username = json['customerLast'];
_name = json['customerEmail'];
_lastLogin = json['customerID'];
_email = json['token'];
}

// exports to json
Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['userId'] = this._userId;
  data['username'] = this._username;
  data['name'] = this._name;
  data['lastLogin'] = this._lastLogin;
  data['email'] = this._email;
  return data;
}
}