import 'dart:async';
import 'dart:io';
import 'package:asm/ui/project_detail.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import '../../main.dart';
import 'dart:convert';

final Set<JavaScriptChannelParams> jsChannels = [
  JavaScriptChannelParams(
      name: 'Print',
      onMessageReceived: (JavaScriptMessage message) {
        print(message.message);
      }),
].toSet();

// ignore: must_be_immutable
class MyWebView extends StatefulWidget {
  final String selectedUrl;
  String generatedUrl = "";
  final String locationHistoryJSON;
  final String locationSharingMethod;
  final String surveyElementCode;
  //String userUUID = '';
  MyWebView(this.selectedUrl, this.locationHistoryJSON,
      this.locationSharingMethod, this.surveyElementCode);
  @override
  _MyWebViewState createState() => _MyWebViewState(selectedUrl,
      locationHistoryJSON, locationSharingMethod, surveyElementCode);
}

class _MyWebViewState extends State<MyWebView> {
  final String selectedUrl;
  String generatedUrl = "";
  final String locationHistoryJSON;
  final String locationSharingMethod;
  final String surveyElementCode;
  String userUUID = GlobalData.userUUID;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late WebViewController _webViewcontroller;

  _MyWebViewState(this.selectedUrl, this.locationHistoryJSON,
      this.locationSharingMethod, this.surveyElementCode);

  @override
  void initState() {
    super.initState();
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    // Initialize platform-specific controller
    late final PlatformWebViewControllerCreationParams params;
    if (Platform.isAndroid) {
      params = const PlatformWebViewControllerCreationParams();
    } else if (Platform.isIOS) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      //..loadRequest(Uri.parse(selectedUrl))
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
            if (url == "https://ee.kobotoolbox.org/thanks" ||
                url == "https://ee-eu.kobotoolbox.org/thanks") {
              debugPrint('MOVING TO THANKS PAGE');
              Navigator.pop(context);
            }
          },
          onPageFinished: (String url) {
            if (url != "https://ee.kobotoolbox.org/thanks" &&
                url != "https://ee-eu.kobotoolbox.org/thanks" &&
                (locationSharingMethod == '1' ||
                    locationSharingMethod == '3')) {
              _setFormLocationHistory();
              debugPrint('Page finished loading: $url');
            }
          },
          onProgress: (int progress) {
            debugPrint("WebView is loading (progress : $progress%)");
          },
          // New method to enable gesture navigation
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(GlobalProjectData.generatedUrl));

    _webViewcontroller = controller;
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        /*actions: <Widget>[
          NavigationControls(_controller.future),
        ],*/
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed('/');
          },
          //      actions: <Widget>[
          //       NavigationControls(_controller.future),
          //    ],
        ),
      ), // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        //generatedUrl = selectedUrl + "?&d[user_id]=" + userUUID + "&d[experiment_status]=" + GlobalProjectData.active_project_status;
        print('userURL web 2: $selectedUrl');
        print('userUUID web 2: $userUUID');
        print(
            'Generated URL: ${GlobalProjectData.generatedUrl}'); // Fix this line
        return WebViewWidget(
          controller: _webViewcontroller,
        );
      }),
    );
  }

  JavaScriptChannelParams _toasterJavascriptChannel(BuildContext context) {
    return JavaScriptChannelParams(
        name: 'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  void _setFormLocationHistory() async {
    //sleep(Duration(seconds: 1));

    //await _webViewcontroller.runJavaScript(
    //'var event = new Event("change", {bubbles: true,}); var this_input = document.getElementsByName("/$surveyElementCode/location_history")[0]; this_input.style.visibility="hidden"; this_input.value = "$locationHistoryJSON"; this_input.dispatchEvent(event);');
    try {
      await _webViewcontroller.runJavaScript('''
      try {
        var event = new Event("change", {bubbles: true});
        var elementName = "/${surveyElementCode}/location_history";
        var this_input = document.getElementsByName(elementName)[0];
        
        if (!this_input) {
          console.error("Element not found: " + elementName);
          return;
        }
        
        this_input.style.visibility = "hidden";
        this_input.value = ${_escapeJsString(locationHistoryJSON)};
        this_input.dispatchEvent(event);
      } catch(e) {
        console.error("JavaScript error: " + e.message);
      }
    ''');
    } catch (e) {
      debugPrint('Error executing JavaScript: $e');
    }
  }
}

// Helper to properly escape strings for JavaScript
String _escapeJsString(String input) {
  // JSON encode gives us proper JS string escaping
  String jsonEncoded = json.encode(input);
  return jsonEncoded;
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller!.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
