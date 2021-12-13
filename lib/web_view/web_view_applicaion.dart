import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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

  Widget _buildWebView(BuildContext context) {
    return WebView(
      initialUrl: 'https://flipkart.com/',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
        controllerGlobal = webViewController;
      },
    );
  }
}
