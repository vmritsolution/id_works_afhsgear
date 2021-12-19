import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:id_works_afhsgear/LoginScreen.dart';
import 'package:id_works_afhsgear/utility/ApiError.dart';
import 'package:id_works_afhsgear/utility/ApiResponse.dart';
import 'package:id_works_afhsgear/utility/TokenUtility.dart';
import 'package:id_works_afhsgear/utility/User.dart';
import 'package:id_works_afhsgear/web_view/web_view_applicaion.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var baseUrl = Uri.parse('https://www.afhsgear.com/api/');
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  String _values = "";

  Future<void> _handleNavigation(String value) async {
    // bool isTokenEmpty = TokenUtility.token.isEmpty;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? values = prefs.getString('customerEmail'); //added
    //added
    if (values != null) {
      print(values);
      setState(() {
        _values = values;
      });
    }
    //added



    getLoginDetails();
    /*bool? isLogOut = await prefs.getBool("isLogOut");
    return isLogOut;*/
  }

  void _handleNavigtion() {}

  @override
  initState() {
    super.initState();
    print(_values);
    // _handleNavigation; //added
    Timer(
      const Duration(seconds: 4),
          () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      ),
    );
  }

  // _startTime() async {
  //   var duration = const Duration(seconds: 10);
  //   return Future.delayed(duration,_delayedWidget);
  // }
  // _delayedWidget(){
  //   return _buildPlatform();
  // }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _buildCupertinoScaffold()
        : _buildMaterialScaffold();
  }

  Widget _buildCupertinoScaffold() {
    return CupertinoPageScaffold(
      child: Container(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildMaterialScaffold() {
    return Scaffold(
      body: Container(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: SvgPicture.asset(
            "assets/splash_svg_bottom.svg",
            fit: BoxFit.fill,
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: mHeight * 0.1),
            child: const SpinKitCircle(
              color: Color(0xFFf88d2a),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: mHeight * 0.2),
            child: SvgPicture.asset("assets/HouseLogoSVG.svg"),
          ),
        )
      ],
    );
    /*SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: (mHeight) * 0.5,
            child: Padding(
              padding:
                  EdgeInsets.only(top: mHeight * 0.2, bottom: mHeight * 0.05),
              child: SizedBox(
                child: SvgPicture.asset("assets/HouseLogoSVG.svg"),
              ),
            ),
          ),
          SizedBox(
            height: (mHeight) * 0.5,
            child: Align(
              alignment: Alignment.bottomRight,"assets/splash_svg_bottom.svg",
              child: Stack(
                children: [
                  SvgPicture.asset(
                    "assets/splash_svg_bottom.svg",
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: mHeight * 0.35),
                    child: SpinKitCircle(
                      color: Colors.deepOrange,
                      size: mHeight * 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )*/
  }

  Future<ApiResponse> authenticateUser(String email, String password) async {
    ApiResponse _apiResponse = ApiResponse();
    try {
      final response = await http.post(baseUrl, body: {
        'action': "login",
        'customerEmail': email,
        'customerPassword': password,
        'siteID': "450",
      });

      switch (response.statusCode) {
        case 200:
          _apiResponse.Data = User.fromJson(json.decode(response.body));
          _saveAndRedirectToHome(_apiResponse, email, password);
          break;
        case 401:
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
        default:
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return _apiResponse;
  }

  void _saveAndRedirectToHome(
      ApiResponse apiResponse, String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", (apiResponse.Data as User).message.token);
    await prefs.setString("Email", email);
    await prefs.setString("Password", password);
    TokenUtility.token = (apiResponse.Data as User).message.token;
    if (apiResponse != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WebViewApplication(),
        ),
      );
    }
  }

  void getLoginDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = await prefs.getString("Email");
    String? password = await prefs.getString("Password");
    if (email != null && password != null) {
      authenticateUser(email, password);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WebViewApplication(),
        ),
      );
    }
  }
}
