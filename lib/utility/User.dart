class User {
  late String _status;
  late Message _message;

  User({required String status,required Message message}) {
    this._status = status;
    this._message = message;
  }

  String get status => _status;
  set status(String status) => _status = status;
  Message get message => _message;
  set message(Message message) => _message = message;

  User.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _message =
    (json['message'] != null ? Message.fromJson(json['message']) : json['message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    if (this._message != null) {
      data['message'] = this._message.toJson();
    }
    return data;
  }
}

class Message {
  late String _customerFirst;
  late String _customerLast;
  late String _customerEmail;
  late String _customerID;
  late String _token;
  late String _customerGUID;

  Message(
      {required String customerFirst,
       required String customerLast,
       required String customerEmail,
       required String customerID,
       required String token,
       required String customerGUID
      }) {
    this._customerFirst = customerFirst;
    this._customerLast = customerLast;
    this._customerEmail = customerEmail;
    this._customerID = customerID;
    this._token = token;
    this._customerGUID = customerGUID;
  }

  String get customerFirst => _customerFirst;
  set customerFirst(String customerFirst) => _customerFirst = customerFirst;
  String get customerLast => _customerLast;
  set customerLast(String customerLast) => _customerLast = customerLast;
  String get customerEmail => _customerEmail;
  set customerEmail(String customerEmail) => _customerEmail = customerEmail;
  String get customerID => _customerID;
  set customerID(String customerID) => _customerID = customerID;
  String get token => _token;
  set token(String token) => _token = token;
  String get customerGUID => _customerGUID;
  set customerGUID(String customerGUID) => _customerGUID = customerGUID;

  Message.fromJson(Map<String, dynamic> json) {
    _customerFirst = json['customerFirst'];
    _customerLast = json['customerLast'];
    _customerEmail = json['customerEmail'];
    _customerID = json['customerID'];
    _token = json['token'];
    _customerGUID = json['customerGUID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerFirst'] = this._customerFirst;
    data['customerLast'] = this._customerLast;
    data['customerEmail'] = this._customerEmail;
    data['customerID'] = this._customerID;
    data['token'] = this._token;
    data['customerGUID'] = this._customerGUID;
    return data;
  }
}
/*
class User{
   String userId;
   String lName;
   String fName;
   String token;
   String email;

   // {"status":"200","message":{"customerFirst":"Bramy","customerLast":"ado","customerEmail":"brahmy143@gmail.com","customerID":"118617","token":"e9af16c3-5d4c-11ec-9753-00259099300e"}}

   User.fromJson(Map json)
      : userId = json['customerID'] ?? "",
  fName = json['customerFirst'] ?? "",
  lName = json['customerLast'] ?? "",
  email = json['customerEmail'] ?? "",
         token = json['token'] ?? "";

  Map toJson() {
  return {'customerID': userId, 'customerFirst': fName, 'customerLast': lName, 'customerEmail': email,'token':token};
  }
}
*/
/*
class User {
  */
/*
  This class encapsulates the json response from the api
  {
      'userId': '1908789',
      'username': username,
      'name': 'Peter Clarke',
      'lastLogin': "23 March 2020 03:34 PM",
      'email': 'x7uytx@mundanecode.com'
  }
  *//*

  late String _userId;
  late String _lName;
  late String _fName;
  late String _token;
  late String _email;

  User(
      {required String userId,
      required String username,
      required String name,
      required String lastLogin,
      required String email}) {
    this._userId = userId;
    this._fName = username;
    this._lName = name;
    this._token = lastLogin;
    this._email = email;
  }

// Properties
  String get userId => _userId;

  set userId(String userId) => _userId = userId;

  String get username => _fName;

  set username(String username) => _fName = username;

  String get name => _lName;

  set name(String name) => _lName = name;

  String get lastLogin => _token;

  set lastLogin(String lastLogin) => _token = lastLogin;

  String get email => _email;

  set email(String email) => _email = email;

// {"status":"200","message":{"customerFirst":"Bramy","customerLast":"ado","customerEmail":"brahmy143@gmail.com","customerID":"118617","token":"e9af16c3-5d4c-11ec-9753-00259099300e"}}
// create the user object from json input

  User.fromJson(Map<String, dynamic> json) {
    _fName = json["customerFirst"] ?? "";
    _lName = json['customerLast'] ?? "";
    _email = json['customerEmail'] ?? "";
    _userId = json['customerID'] ?? "";
    _token = json['token'] ?? "";
  }

// exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this._userId;
    data['username'] = this._fName;
    data['name'] = this._lName;
    data['lastLogin'] = this._token;
    data['email'] = this._email;
    return data;
  }
}
*/
