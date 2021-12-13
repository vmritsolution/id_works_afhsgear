import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  WebViewController? webViewController;

  WebViewPage(this.webViewController);

  @override
  createState() => _WebViewPageState(webViewController);
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? _webViewController;

  _WebViewPageState(this._webViewController);

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://amazon.in/',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
        _webViewController = webViewController;
      },
    );
  }
}
