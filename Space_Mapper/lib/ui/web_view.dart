/*import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

const String selectedUrl = 'https://ee.kobotoolbox.org/single/asCwpCjZ';

const String userUUID_element = '/asRrkkAw4mUtpTDkjdzZzt/group_survey/userUUID';

const String userUUID_label = userUUID_element + ':label';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class MyWebView extends StatefulWidget {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String userUuid;
  bool uuidSet = false;

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onProgressChanged;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;

  final _urlCtrl = TextEditingController(text: selectedUrl);

  final _codeCtrl = TextEditingController(text: 'window.navigator.userAgent');

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _history = [];

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.close();

    _getUserUUID().then((_thisId) {
      userUuid = _thisId;
    });

    _urlCtrl.addListener(() {
      //    selectedUrl = _urlCtrl.text;
    });

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: const Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (url == "https://ee.kobotoolbox.org/thanks") {
        Navigator.pop(context);
      }

      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
        });
      }
    });

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          _history.add('onProgressChanged: $progress');
        });
      }
    });

    _onScrollYChanged =
        flutterWebViewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in Y Direction: $y');

          if (userUuid != null) {
            _setFormUUID(userUuid);
          } else {
            _getUserUUID().then((_thisId) {
              userUuid = _thisId;
              _setFormUUID(userUuid);
            });
          }
        });
      }
    });

    _onScrollXChanged =
        flutterWebViewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in X Direction: $x');
        });
      }
    });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((viewState) async {
      if (mounted) {
        setState(() {
          _history.add('onStateChanged: ${viewState.type} ${viewState.url}');
        });
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _history.add('onHttpError: ${error.code} ${error.url}');
        });
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: selectedUrl,
      appBar: AppBar(
        title: const Text('Survey'),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Colors.grey,
        child: const Center(
          child: const Text('Loading...'),
        ),
      ),
    );
  }

  Future<String> _getUserUUID() async {
    SharedPreferences prefs = await _prefs;
    String _userUuid = prefs.getString("user_uuid");
    if (_userUuid == null) {
      prefs.setString("user_uuid", Uuid().v4());
    }
    print(_userUuid);
    return (_userUuid);
  }

  void _setFormUUID(_thisId) {
    flutterWebViewPlugin.evalJavascript(
        'var event = new Event("change", {bubbles: true,cancelable: true,}); var this_input = document.getElementsByName("' +
            userUUID_element +
            '")[0];this_input.value="' +
            _thisId +
            '";this_input.dispatchEvent(event); this_input.style.visibility = "hidden"; var id_labels = document.querySelectorAll("[data-itext-id=\'' +
            userUUID_label +
            '\']"); for (var i = 0; i < id_labels.length; i++) id_labels[i].innerHTML = "ID: ' +
            _thisId +
            '";');
    print(_thisId);
    print("URL " + selectedUrl);
  }
}
*/