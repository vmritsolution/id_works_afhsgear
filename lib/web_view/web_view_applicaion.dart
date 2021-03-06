import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:id_works_kwiktripmerch/LoginScreen.dart';
import 'package:id_works_kwiktripmerch/utility/TokenUtility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewApplication extends StatefulWidget {
  const WebViewApplication({Key? key}) : super(key: key);

  @override
  _WebViewApplicationState createState() => _WebViewApplicationState();
}

WebViewController? controllerGlobal;

Future<bool> _handleBack(context) async {
  var status = await controllerGlobal!.canGoBack();
  if (status) {
    controllerGlobal!.goBack();
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Are you sure exit App'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('Yes'),
          )
        ],
      ),
    );
  }
  return Future.value(false);
}

class _WebViewApplicationState extends State<WebViewApplication> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.remove('token');
    prefs.setBool("isLogOut", true);
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
    // Navigator.pop(context);
  }

  Widget _buildScaffold() {
    return WillPopScope(
      onWillPop: () => _handleBack(context),
      child: SafeArea(
        child: Platform.isIOS
            ? _buildCupertinoScaffold()
            : _buildMaterialScaffold(),
      ),
    );
  }

  Widget _buildCupertinoScaffold() {
    return CupertinoPageScaffold(
      child: _buildWebView(context),
    );
  }

  Widget _buildMaterialScaffold() {
    return Scaffold(
      body: _buildWebView(context),
    );
  }

  // final _listeningUrl = 'https://www.afhsgear.com/login.php'; // added this
  final _listeningUrl = 'https://kwiktripmerch.com/login.php'; // added this



  int _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  void _handleLogOutLoader() {
    setState(() {
      _stackToView = 2;
    });
  }

  Widget _buildWebView(BuildContext context) {

    return IndexedStack(
      index: _stackToView,
      children: [
        Theme(
          data: ThemeData(dialogBackgroundColor: Colors.transparent),
          child: WebView(
            initialUrl: 'https://kwiktripmerch.com/autologin.php?app=1&token=${TokenUtility.token}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
              controllerGlobal = webViewController;
            },

            // added this
            onPageStarted: (url) {
              if (url.contains(_listeningUrl)) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      title: SpinKitCircle(
                        color: Color(0xffce0e2d),
                      ),
                    );
                  },
                );
                _handleLogout();
                /*Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );*/
              }
              print(url);
            },
            onPageFinished: _handleLoad,
          ),
        ),
        Container(
          color: Colors.white,
          child: const Center(
            child: SpinKitCircle(
              color: Color(0xffce0e2d),
            ),
          ),
        ),
      ],
    );
  }
}
