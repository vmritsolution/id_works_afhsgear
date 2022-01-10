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
  final Color color = HexColor.fromHex('#ce0e2d');

  /*Future<void> _handleNavigation(String value) async {
    // bool isTokenEmpty = TokenUtility.token.isEmpty;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String values = (prefs.getString('customerEmail')!); //added
    //added
    if (values != null) {
      print(values);
      setState(() {
        _values = values;
      });
    }
    //added

    getLoginDetails();
    *//*bool? isLogOut = await prefs.getBool("isLogOut");
    return isLogOut;*//*
  }*/

  @override
  initState() {
    super.initState();
    getLoginDetails();
  }



  @override
  Widget build(BuildContext context) {
    return /*Platform.isIOS
        ? _buildCupertinoScaffold()
        : _buildMaterialScaffold();*/
    _buildMaterialScaffold();
  }

  Widget _buildCupertinoScaffold() {
    return CupertinoPageScaffold(
      backgroundColor:const Color(0xffce0e2d),
      child: Container(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildMaterialScaffold() {
    return Scaffold(
      backgroundColor:const Color(0xffce0e2d),
      body: Container(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        /*Align(
          alignment: Alignment.bottomRight,
          child: SvgPicture.asset(
            "assets/splash_svg_bottom.svg",
            fit: BoxFit.fill,
          ),
        ),*/
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: mHeight * 0.1),
            child: const SpinKitCircle(
              color: Color(0xffce0e2d),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: mHeight * 0.2),
            child: SvgPicture.asset("assets/KwikTripMerchTransparent.svg"),
            // child: Image.asset("assets/KwikTripMerchTransparent.png"),

          ),
        )
      ],
    );
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

  String _email = '';
  String _password = '';

  void getLoginDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    /*String? email = await prefs.getString("Email");
    String? password = await prefs.getString("Password");
    if (email != null && password != null) {
      authenticateUser(email, password);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WebViewApplication(),
        ),
      );
    }*/
    setState(() {
      _email = (prefs.getString("Email") ?? '');
      _password = (prefs.getString("Password") ?? '');
    });
    if (_email == '' && _password == '') {
      Timer(
        const Duration(seconds: 4),
            () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        ),
      );
    } else {
      authenticateUser(_email, _password);
      Timer(
        const Duration(seconds: 4),
            () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WebViewApplication(),
          ),
        ),
      );
    }
  }
}
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
