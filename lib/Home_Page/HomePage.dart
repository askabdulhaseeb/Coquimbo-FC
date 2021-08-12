import 'dart:io';
import 'package:back_pressed/back_pressed.dart';
import 'package:connectivity/connectivity.dart';
import 'package:coquimbofc/Check_Connection/No%20Internet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomePage extends StatefulWidget {
  final String url;

  HomePage({Key? key, required this.url}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int checkInt = 0;
  late ConnectivityResult previous;







  @override
  void initState() {
    super.initState();


    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.blue),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController?.reload();
        } else if (Platform.isIOS) {
          _webViewController?.loadUrl(
              urlRequest: URLRequest(url: await _webViewController?.getUrl()));
        }
      },
    );


    Connectivity().onConnectivityChanged.listen((ConnectivityResult connresult){
      if(connresult == ConnectivityResult.none){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => No_Internet_Connection()), (route) => false );
      }else if(previous == ConnectivityResult.none){
        // internet conn
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => No_Internet_Connection()), (route) => false );
      }

      previous = connresult;
    });




  }


  InAppWebViewController? _webViewController;
  String url = '';

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptEnabled: true,
        useShouldOverrideUrlLoading: true,
        useOnDownloadStart: true,
        javaScriptCanOpenWindowsAutomatically: true,
      ),
      android: AndroidInAppWebViewOptions(
        initialScale: 100,
        useShouldInterceptRequest: true,
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  final urlController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(14, 129, 154,1),
      statusBarBrightness: Brightness.dark,
    ));

    return OnBackPressed(
      perform: (){
        _webViewController!.goBack();
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Expanded(
                  child: InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(
                      url: Uri.parse(widget.url),
                      headers: {},
                    ),
                    initialOptions: options,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController.endRefreshing();
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onLoadError: (controller, url, code, message) {
                      pullToRefreshController.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController.endRefreshing();
                      }
                      setState(() {
                        // this.progress = progress / 100;
                        urlController.text = this.url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
