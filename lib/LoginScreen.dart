import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:id_works_kwiktripmerch/ForgotPasswordScreen.dart';
import 'package:id_works_kwiktripmerch/utility/ApiError.dart';
import 'package:id_works_kwiktripmerch/utility/ApiResponse.dart';
import 'package:id_works_kwiktripmerch/utility/NotificationsUtility.dart';
import 'package:id_works_kwiktripmerch/utility/TokenUtility.dart';
import 'package:id_works_kwiktripmerch/utility/User.dart';
import 'package:id_works_kwiktripmerch/web_view/WebViewContinueGuest.dart';
import 'package:id_works_kwiktripmerch/web_view/WebViewRegistration.dart';
import 'package:id_works_kwiktripmerch/web_view/web_view_applicaion.dart';
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
  // var baseUrl = Uri.parse('https://www.afhsgear.com/api/');
  var baseUrl = Uri.parse('https://kwiktripmerch.com/api/');
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  String messageTitle = "Empty";
  String notificationAlert = "alert";

  //added newly
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';
  bool _obscureText = false;

  @override
  void initState() {
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();

    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    super.initState();
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
    return WillPopScope(
        onWillPop: () async => false,
    child:Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: _buildBody(context),
      ),
    )
    );
  }

  Widget _buildBody(BuildContext bodyContext) {
    final mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            height: mediaQuery.height * 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    // SizedBox(height: mediaQuery.height * 0.03),
                    /*const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 28),
                      ),
                    ),*/
                    // SizedBox(height: mediaQuery.height * 0.04),
                    /*Platform.isIOS
                        ? _cupertinoTextField()
                        : _materialTextField(),*/
                    _materialTextField(),
                    // SizedBox(height: mediaQuery.height * 0.01),
                  Container(
                    child: Platform.isIOS
                      ? _cupertinoRegisterButton()
                      : _materialRegisterButton(),
                  ),
/*                    const Align(
                        alignment: Alignment.centerRight,
                        child:Text(
                      'Register For An Account',
                      style: TextStyle(
                        color: Color(0xffce0e2d),
                        fontSize: 19,
                      ),
                    )
                    )*/
                    SizedBox(height: mediaQuery.height * 0.03),
                    Platform.isIOS
                        ? _cupertinoLoginButton()
                        : _materialLoginButton(bodyContext),

                    SizedBox(height: mediaQuery.height * 0.03),

                    _guestUser(),

                    SizedBox(height: mediaQuery.height * 0.03),
                // Expanded(
                   Platform.isIOS
                        ? _cupertinoTextButton()
                        : _materialTextButton(),
                // )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _guestUser(){
    return Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
    ),
    child:
    /*OutlinedButton(
      onPressed: null,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
      ),
      child: const Text("Continue as Guest",style: TextStyle(color: Color(0xffce0e2d)),
      ),
    )
    );*/
      TextButton(
          child: Text(
              "Continue As Guest".toUpperCase(),
              style: const TextStyle(fontSize: 14)
          ),
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xffce0e2d)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: const BorderSide(color: Color(0xffce0e2d))
                  )
              )
          ),
          onPressed: () => {
          Navigator.of(context).push(
          MaterialPageRoute(
          builder: (context) => const WebViewContinueGuest(),
          ),
          )
      }

      ));
  }
  Widget _homeLogoWidget() {
    return SizedBox(
      height: 150,
      width: 150,
      child: SvgPicture.asset("assets/KwikTripMerchlogo.svg"),
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
              borderSide: const BorderSide(color: Color(0xffce0e2d), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(color: Color(0xffce0e2d), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(color: Color(0xffce0e2d), width: 2),
            ),
          ),
        ),
        SizedBox(height: mediaQuery.height * 0.04),
        TextFormField(
          textInputAction: TextInputAction.done,
          obscureText: !_obscureText,
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
              borderSide: const BorderSide(color: Color(0xffce0e2d), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(color: Color(0xffce0e2d), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(color: Color(0xffce0e2d), width: 2),
            ),
             suffixIcon: GestureDetector(
              onTap: () {
               _toggle();
               },
              child: Icon(
               _obscureText ? Icons.visibility : Icons
        .visibility_off, color: Colors.red,),
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
//0xFFf88d2d previous color code
  Widget _materialLoginButton(BuildContext logInContext) {
    return Theme(
      data: ThemeData(dialogBackgroundColor: Colors.transparent),
      child: Builder(builder: (builderContext) {
        return Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: const Color(0xffce0e2d),
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
              primary: const Color(0xffce0e2d),
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
      color: const Color(0xffce0e2d),
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
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ForgotPasswordScreen(),
          ),
        );
      },
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
  Widget _cupertinoRegisterButton() {
    return CupertinoButton(
      child: const Align(
        alignment: Alignment.centerRight,
      child: Text(
        'Register For An Account',
        style: TextStyle(
          color: Color(0xffce0e2d),
          fontSize: 17,
        ),
      ),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WebViewRegistration(),
          ),
        );
      },
    );
  }

  Widget _materialRegisterButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WebViewRegistration(),
          ),
        );
      },
      child:const Align(
      alignment: Alignment.centerRight,
    child:Text(
        'Register For An Account',
        style: TextStyle(
          color: Color(0xffce0e2d),
          fontSize: 17,
        ),
      ),
    ));
  }

  var jsonResponse;

  Future<ApiResponse> authenticateUser(String username, String password) async {
    ApiResponse _apiResponse = ApiResponse();
    try {
      final response = await http.post(baseUrl, body: {
        'action': "login",
        'customerEmail': emailController.text,
        'customerPassword': passwordController.text,
        'siteID': "1009",
      });
      if(response.body.isNotEmpty) {
        jsonResponse = json.decode(response.body);
      }
      print("heyres:"+response.body);
      switch (response.statusCode) {
        case 200:
          _formKey.currentState!.validate();
          Navigator.pop(context);
          if(jsonResponse['status']=="400"){
            _showSnackBar(context, 'Username and password are not valid');
/*            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );*/

          }else if(jsonResponse['status']=="200"){

/*
          if (jsonResponse['message'] == 'username and pass are not valid') {
            _showSnackBar(context, 'Username and password are not valid');
          }
*/
          _apiResponse.Data = User.fromJson(json.decode(response.body));

          // _saveAndRedirectToHome(_apiResponse);

          String cuid=(_apiResponse.Data as User).message.customerGUID;
          String cid=(_apiResponse.Data as User).message.customerID;
          String token=(_apiResponse.Data as User).message.token;

          addDeviceToken(cuid,cid,token,_apiResponse);

          }
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
  Future<ApiResponse> addDeviceToken(String CUID,String CID,String token,ApiResponse apiResponse) async {
    ApiResponse _apiResponse = ApiResponse();
    print("hey:"+token+"::"+CID+":::"+CUID);
    try {
      final response = await http.post(baseUrl, body: {
        'action': "addDevice",
        'customerID': CID,
        'deviceType': "2",
        'deviceToken': token,
        'customerGUID': CUID,
      });
      print("jsonbody:${response.request}");
      switch (response.statusCode) {
        case 200:
          _saveAndRedirectToHome(apiResponse);
          break;
        case 400:
          break;

        default:
          _showSnackBar(
              context, "Something Went Wrong,Please try again!!"); //added
          break;
      }
    } on SocketException {
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
      // Notify();
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
              Center(child: SpinKitCircle(color: Color(0xffce0e2d)))
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
