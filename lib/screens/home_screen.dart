import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  String url = "Your url here"; //Add web url here

  InAppWebViewController? webView;
  double progress = 0;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen((result) {
        setState(() {
          isDeviceConnected = (result != ConnectivityResult.none);
        });
      });

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await webView!.canGoBack()) {
          webView!.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: isDeviceConnected
              ? InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(
                        url),
                  ),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      useShouldOverrideUrlLoading: true,
                      mediaPlaybackRequiresUserGesture: false,
                    ),
                    android: AndroidInAppWebViewOptions(
                      useHybridComposition: true,
                    ),
                    ios: IOSInAppWebViewOptions(
                      allowsInlineMediaPlayback: true,
                    ),
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  onProgressChanged: (controller, progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 35.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Oops. Looks like there\'s no internet connection. Check your connection and try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  showDialogBox() => showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your Internet Connection'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() {
                  isAlertSet = false;
                });
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected) {
                  showDialogBox();
                  setState(() {
                    isAlertSet = true;
                  });
                }
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
}
