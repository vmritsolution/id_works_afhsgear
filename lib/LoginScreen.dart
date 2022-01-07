import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:id_works_afhsgear/ForgotPasswordScreen.dart';
import 'package:id_works_afhsgear/utility/ApiError.dart';
import 'package:id_works_afhsgear/utility/ApiResponse.dart';
import 'package:id_works_afhsgear/utility/NotificationsUtility.dart';
import 'package:id_works_afhsgear/utility/TokenUtility.dart';
import 'package:id_works_afhsgear/utility/User.dart';
import 'package:id_works_afhsgear/web_view/web_view_applicaion.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var baseUrl = Uri.parse('https://www.afhsgear.com/api/');
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  String messageTitle = "Empty";
  String notificationAlert = "alert";

  //added newly
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  @override
  void initState() {
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();

    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    super.initState();
  }

  _changeData(String msg) => setState(() => notificationData = msg);

  _changeBody(String msg) => setState(() => notificationBody = msg);

  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  Widget build(BuildContext scaffoldContext) {
    return Platform.isIOS
        ? _buildCupertinoScaffold(scaffoldContext)
        : _buildMaterialScaffold(scaffoldContext);
  }

  Widget _buildCupertinoScaffold(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Container(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildMaterialScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext bodyContext) {
    final mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            height: mediaQuery.height * 0.9,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _homeLogoWidget(),
                    SizedBox(height: mediaQuery.height * 0.1),
                    /*const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Welcome!',
                        style: TextStyle(fontSize: 36),
                      ),
                    ),*/
                    SizedBox(height: mediaQuery.height * 0.03),
                    /*const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 28),
                      ),
                    ),*/
                    SizedBox(height: mediaQuery.height * 0.04),
                    /*Platform.isIOS
                        ? _cupertinoTextField()
                        : _materialTextField(),*/
                    _materialTextField(),
                    SizedBox(height: mediaQuery.height * 0.04),
                    Platform.isIOS
                        ? _cupertinoLoginButton()
                        : _materialLoginButton(bodyContext),
                    SizedBox(height: mediaQuery.height * 0.03),
                    Platform.isIOS
                        ? _cupertinoTextButton()
                        : _materialTextButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _homeLogoWidget() {
    return SizedBox(
      height: 150,
      width: 150,
      child: SvgPicture.asset("assets/HouseLogoSVG.svg"),
    );
  }

  Widget _materialTextField() {
    final mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        //added
        TextFormField(
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.isEmpty) {
              _isEmailValid = false;
              return 'Please Enter Valid Email';
            } else {
              if (isEmailValid(value)) {
                _isEmailValid = true;
                return '';
              } else {
                return 'Please Enter Valid Email';
              }
            }
          },
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email Address",
            labelStyle: const TextStyle(color: Colors.black, fontSize: 18),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(color: Color(0xFFf88d2d), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(color: Color(0xFFf88d2d), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(color: Color(0xFFf88d2d), width: 2),
            ),
          ),
        ),
        SizedBox(height: mediaQuery.height * 0.04),
        TextFormField(
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value!.isEmpty) {
              _isPasswordValid = false;
              return 'Please Enter Valid Password';
            } else {
              _isPasswordValid = true;
              return '';
            }
          },
          controller: passwordController,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            labelText: "Password",
            labelStyle: const TextStyle(color: Colors.black, fontSize: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(color: Color(0xFFf88d2d), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(color: Color(0xFFf88d2d), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(color: Color(0xFFf88d2d), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  bool isEmailValid(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return (!regex.hasMatch(value)) ? false : true;
  }

  Widget _cupertinoTextField() {
    final mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        const CupertinoTextField(
          decoration: BoxDecoration(),
          placeholder: "Email Address",
        ),
        SizedBox(height: mediaQuery.height * 0.04),
        const CupertinoTextField(
          decoration: BoxDecoration(),
          placeholder: "Password",
        )
      ],
    );
  }

  Widget _materialLoginButton(BuildContext logInContext) {
    return Theme(
      data: ThemeData(dialogBackgroundColor: Colors.transparent),
      child: Builder(builder: (builderContext) {
        return Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: const Color(0xFFf88d2d),
          ),
          child: ElevatedButton(
            onPressed: () {
              //added
              _formKey.currentState!.validate();
              if (_isEmailValid && _isPasswordValid) {
                _submitDialog(context);
                authenticateUser(emailController.text, passwordController.text);
              } else {
                _showSnackBar(context, "Please Provide Valid Credentials");
              }
            },
            child: const Text(
              'LOGIN',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFFf88d2d),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _cupertinoLoginButton() {
    return CupertinoButton(
      child: const Text(
        'LOGIN',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () {
        if (_isEmailValid && _isPasswordValid) {
          _submitDialog(context);
          authenticateUser(emailController.text, passwordController.text);
        } else {
          _showSnackBar(context, "Please Provide Valid Credentials");
        }
      },
      color: const Color(0xFFf88d2d),
    );
  }

  Widget _cupertinoTextButton() {
    return CupertinoButton(
      child: const Text(
        'Forgot password?',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _materialTextButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ForgotPasswordScreen(),
          ),
        );
      },
      child: const Text(
        'Forgot password?',
        style: TextStyle(
          color: Colors.black,
          fontSize: 19,
        ),
      ),
    );
  }

  var _response;

  Future<ApiResponse> authenticateUser(String username, String password) async {
    ApiResponse _apiResponse = ApiResponse();
    try {
      final response = await http.post(baseUrl, body: {
        'action': "login",
        'customerEmail': emailController.text,
        'customerPassword': passwordController.text,
        'siteID': "450",
      });
      _response = response.statusCode; // added
      var jsonResponse = json.decode(response.body);
      switch (response.statusCode) {
        case 200:
          _formKey.currentState!.validate();
          Navigator.pop(context);
          // added
          if (jsonResponse['message'] == 'username and pass are not valid') {
            _showSnackBar(context, 'Username and password are not valid');
          }
          _apiResponse.Data = User.fromJson(json.decode(response.body));
          _saveAndRedirectToHome(_apiResponse);
          // }
          break;
        case 400:
          Navigator.pop(context);
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          _showSnackBar(
              context, "Something Went Wrong,Please try again!"); //added
          break;
        default:
          Navigator.pop(context);
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          _showSnackBar(
              context, "Something Went Wrong,Please try again!!"); //added
          break;
      }
    } on SocketException {
      Navigator.pop(context);
      _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
      _showSnackBar(context, "Server error. Please retry"); //added
    }
    return _apiResponse;
  }

  void _saveAndRedirectToHome(ApiResponse apiResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", (apiResponse.Data as User).message.token);
    await prefs.setString("Email", emailController.text);
    await prefs.setString("Password", passwordController.text);
    TokenUtility.token = (apiResponse.Data as User).message.token;
    if (apiResponse != null) {
      Notify();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WebViewApplication(),
        ),
      );
    }
  }

  Future<Null> _submitDialog(BuildContext context) async {
    return await showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const SimpleDialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Center(child: SpinKitCircle(color: Color(0xFFf88d2a)))
            ],
          );
        });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void Notify() async {
    // local notification
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'Simple Notification',
            body: 'Simple body',
            bigPicture: 'assets://images/protocoderlogo.png'));
  }
}
