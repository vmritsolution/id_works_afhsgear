import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:id_works_kwiktripmerch/LoginScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
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
                    const SizedBox(height: 90),
                    _materialTextField(context),
                    const SizedBox(height: 50),
                    _forgotPasswordButton(context),
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
      // child: SvgPicture.asset("assets/HouseLogoSVG.svg"),
      child: SvgPicture.asset("assets/KwikTripMerchlogo.svg"),
    );
  }

  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;

  bool isEmailValid(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return (!regex.hasMatch(value)) ? false : true;
  }

  Widget _materialTextField(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          _isEmailValid = false;
          return 'Please Enter Email';
        } else {
          if (isEmailValid(value)) {
            _isEmailValid = true;
            return '';
          } else {
            return 'Please Enter Valid Email';
          }
        }
      },
      controller: _emailController,
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
    );
  }

  Widget _forgotPasswordButton(BuildContext contextNew) {
    return Builder(builder: (contextNew) {
      return SizedBox(
        height: 50,
        width: 250,
        child: ElevatedButton(
          onPressed: () {
            _formKey.currentState?.validate();
            if (_isEmailValid == true) {
              _submitDialog(context);
              _forgotPasswordAuth(_emailController.text);
            }
            /*_isEmailValid ? _submitDialog(context) : false;*/
          },
          child: const Text(
            "FORGET PASSWORD",
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
    });
  }

  void isValidate() {
    setState(() {
      isValid = false;
    });
  }

  Future<void> _forgotPasswordAuth(String email) async {
    final response =
        await http.post(Uri.parse('https://kwiktripmerch.com/api/'), body: {
      'action': "forgotPassword",
      'customerEmail': email,
      'siteID': "1009",
    });
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    /*isValid ? _submitDialog(context) : Navigator.pop(context);*/
    /* if(jsonResponse != null){
      setState(() {
        _isEmailValid = false;
      });
    }*/
    Navigator.pop(context);
    // if(jsonResponse['status']==200) {
      if (jsonResponse['message'] == null) {
        print(jsonResponse['message']);
        _showSnackBar(context, "Please Enter Valid Email");

        // _showDialog(context, 'Please Enter Valid Email');
      } else if (jsonResponse['message'] == true) {
        _showSnackBar(context, "Please Check Your Email");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );

        // _showDialog(context, 'Please Check Your Email');
      } else {
        _showSnackBar(context, "Something went wrong Please try again!");
        // _showDialog(context, 'Something went wrong Please try again!');
      }
    /*}else{
      _showSnackBar(context, "Something went wrong Please try again!");
    }*/
    /*else if (jsonResponse['message'] == 'true') {
      Navigator.of(context).pop();
      _showDialog(context, 'Please Check your Mail');
    }*/
    /*else{
      Navigator.of(context).pop();
    }*/
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

  _submitDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
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

  _showDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            elevation: 0.0,
            backgroundColor: Colors.white,
            children: <Widget>[
              Center(
                  child: Text(
                message,
                style: const TextStyle(fontSize: 18),
              )),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          );
        });
  }
}
