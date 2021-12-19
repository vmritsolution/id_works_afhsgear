import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:id_works_afhsgear/utility/ApiError.dart';
import 'package:id_works_afhsgear/utility/ApiResponse.dart';
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var baseUrl = Uri.parse('https://www.afhsgear.com/api/');

  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _buildCupertinoScaffold()
        : _buildMaterialScaffold();
  }

  Widget _buildCupertinoScaffold() {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Container(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildMaterialScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
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
                    Platform.isIOS
                        ? _cupertinoTextField()
                        : _materialTextField(),
                    SizedBox(height: mediaQuery.height * 0.04),
                    Platform.isIOS
                        ? _cupertinoLoginButton()
                        : _materialLoginButton(),
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
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter email';
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
          //added
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter Password';
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

  Widget _materialLoginButton() {
    return Theme(
      data: ThemeData(dialogBackgroundColor: Colors.transparent),
      child: Builder(builder: (context) {
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

              if (_formKey.currentState!.validate()) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      title: SpinKitCircle(
                        color: Color(0xFFf88d2a),
                      ),
                    );
                  },
                );
              }
              authenticateUser(emailController.text, passwordController.text);
/*
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewApplication(),
                  ),
                );
*/
            },
            child: const Text(
              'LOGIN',
              style: TextStyle(color: Colors.white, fontSize: 22),
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
        style: TextStyle(color: Colors.white, fontSize: 28),
      ),
      onPressed: () {
        authenticateUser(emailController.text, passwordController.text);
        debugPrint("heyEmail:" + emailController.text);
        // authenticate(emailController.text, passwordController.text);
/*
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WebViewApplication(),
          ),
        );
*/
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
      onPressed: () {},
      child: const Text(
        'Forgot password?',
        style: TextStyle(
          color: Colors.black,
          fontSize: 19,
        ),
      ),
    );
  }

  /* void _handleSubmitted() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      _apiResponse = await authenticateUser(_username, _password);
      if ((_apiResponse.ApiError as ApiError) == null) {
        _saveAndRedirectToHome();
      } else {
        showInSnackBar((_apiResponse.ApiError as ApiError).error);
      }
    }
  }

  void _saveAndRedirectToHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userId", (_apiResponse.Data as User).userId);
    Navigator.pushNamedAndRemoveUntil(
        context, '/home', ModalRoute.withName('/home'),
        arguments: (_apiResponse.Data as User));
  }*/
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
      _response = response.statusCode;// added
      switch (response.statusCode) {
        case 200:
          _apiResponse.Data = User.fromJson(json.decode(response.body));
          _saveAndRedirectToHome(_apiResponse);
          break;
        case 401:
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          _showSnackBar();//added
          break;
        default:
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          _showSnackBar();//added
          break;
      }
    } on SocketException {
      _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WebViewApplication(),
        ),
      );
    }
  }
  //added
  void _showSnackBar(){
    final snackBar = SnackBar(
      content: const Text("Something Went Wrong"),
      action: SnackBarAction(
        label: "undo",
        onPressed: (){},
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
