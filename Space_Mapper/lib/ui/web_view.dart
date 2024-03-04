import 'dart:async';
import 'dart:io';
import 'package:asm/ui/project_detail.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../main.dart';

const String userUUID_element = '/asRrkkAw4mUtpTDkjdzZzt/group_survey/userUUID';
const String userUUID_label = userUUID_element + ':label';

final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

// ignore: must_be_immutable
class MyWebView extends StatefulWidget {
  final String selectedUrl;
  String generatedUrl = "";
  final String locationHistoryJSON;
  final String locationSharingMethod;
  //String userUUID = '';
  MyWebView(this.selectedUrl, this.locationHistoryJSON, this.locationSharingMethod);
  @override
  _MyWebViewState createState() =>
      _MyWebViewState(selectedUrl, locationHistoryJSON, locationSharingMethod);

}

class _MyWebViewState extends State<MyWebView> {
  final String selectedUrl;
  String generatedUrl = "";
  final String locationHistoryJSON;
  final String locationSharingMethod;
  String userUUID= GlobalData.userUUID;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late WebViewController _webViewcontroller;

  _MyWebViewState(this.selectedUrl, this.locationHistoryJSON, this.locationSharingMethod);

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

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
        leading: IconButton(icon: Icon(Icons.arrow_back),
         onPressed: () {
    Navigator.of(context).pushNamed('/');},
  //      actions: <Widget>[
   //       NavigationControls(_controller.future),
    //    ],
      ),
      ),// We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        //generatedUrl = selectedUrl + "?&d[user_id]=" + userUUID + "&d[experiment_status]=" + GlobalProjectData.active_project_status;
              print('userURL web 2: $selectedUrl'); 
              print('userUUID web 2: $userUUID'); 
              print('userUUID web 2: $GlobalProjectData.generatedUrl'); 
        return WebView(
          //initialUrl: selectedUrl + userUUID,
          initialUrl: GlobalProjectData.generatedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
            _webViewcontroller = webViewController;
          },
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          onPageStarted: (String url) {
             print('Page started loading: $url');
             if(url == "https://ee.kobotoolbox.org/thanks"){
              print('MOVING TO THANKS PAGE');
              Navigator.pop(context);
             }

          },
          onPageFinished: (String url) {

          if(url != "https://ee.kobotoolbox.org/thanks" && (locationSharingMethod == '1' || locationSharingMethod == '3') ){

            _setFormLocationHistory();
            print('Page finished loading: $url');
          }
          },
          gestureNavigationEnabled: true,
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  void _setFormLocationHistory() async {
    sleep(Duration(seconds: 1));

    await _webViewcontroller.runJavascript(
        'var event = new Event("change", {bubbles: true,}); var this_input = document.getElementsByName("/aMz7EhF3ZpzMvNUMwtR4eN/participating_button_group/location_history")[0]; this_input.value = "$locationHistoryJSON"; this_input.dispatchEvent(event);');
   }
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
