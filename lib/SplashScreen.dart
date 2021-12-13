
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:id_works_afhsgear/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
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
          child:  Padding(
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
    )
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
        ;
  }
}
