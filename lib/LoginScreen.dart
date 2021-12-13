import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:id_works_afhsgear/utils/SessionsUtility.dart';
import 'package:id_works_afhsgear/web_view/web_view_applicaion.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
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
                  SizedBox(height: mediaQuery.height * 0.05),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Welcome!',
                      style: TextStyle(fontSize: 36),
                    ),
                  ),
                  SizedBox(height: mediaQuery.height * 0.03),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                  SizedBox(height: mediaQuery.height * 0.04),
                  Platform.isIOS ? _cupertinoTextField() : _materialTextField(),
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
    );
  }

  Future<void> saveData(context,email,password) async {
    SessionsUtility myData = SessionsUtility(userName: email,password:password);

    await FlutterSession().set('myData', myData);
    //navigate to webview
    // Navigator.push(context, MaterialPageRoute(builder: (_context) => Page2()));
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
        TextFormField(
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
    return Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: const Color(0xFFf88d2d),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WebViewApplication(),
            ),
          );
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
  }

  Widget _cupertinoLoginButton() {
    return CupertinoButton(
      child: const Text(
        'LOGIN',
        style: TextStyle(color: Colors.white, fontSize: 28),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WebViewApplication(),
          ),
        );
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
}
