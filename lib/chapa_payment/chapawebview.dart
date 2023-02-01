import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'constants/common.dart';
import 'constants/strings.dart';

class ChapaWebView extends StatefulWidget {
  final String url;
  final String fallBackNamedUrl;
  final String transactionReference;
  final String amountPaid;

  //ttx
  //amount
  //description
  //

  const ChapaWebView(
      {Key? key,
      required this.url,
      required this.fallBackNamedUrl,
      required this.transactionReference,
      required this.amountPaid})
      : super(key: key);

  @override
  State<ChapaWebView> createState() => _ChapaWebViewState();
}

class _ChapaWebViewState extends State<ChapaWebView> {
  late InAppWebViewController webViewController;
  String url = "";
  double progress = 0;
  StreamSubscription? connection;
  bool isOffline = false;

  @override
  void initState() {
    checkConnectivity();

    super.initState();
  }

  void checkConnectivity() {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isOffline = true;
        });
        showErrorToast(ChapaStrings.connectionError);

        exitPaymentPage(ChapaStrings.connectionError);
      } else if (result == ConnectivityResult.mobile) {
        setState(() {
          isOffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          isOffline = false;
        });
      } else if (result == ConnectivityResult.ethernet) {
        setState(() {
          isOffline = false;
        });
      } else if (result == ConnectivityResult.bluetooth) {
        setState(() {
          isOffline = false;
        });
        exitPaymentPage(ChapaStrings.connectionError);
      }
    });
  }

  void exitPaymentPage(String message) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      widget.fallBackNamedUrl,
      arguments: {
        'message': message,
        'transactionReference': widget.transactionReference,
        'paidAmount': widget.amountPaid
      },
    );

    // Navigator.pushNamed(
    //   context,
    //   widget.fallBackNamedUrl,
    //   arguments: {
    //     'message': message,
    //     'transactionReference': widget.transactionReference,
    //     'paidAmount': widget.amountPaid
    //   },
    // );
  }

  @override
  void dispose() {
    super.dispose();
    connection!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(children: <Widget>[
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
              onWebViewCreated: (controller) {
                setState(() {
                  webViewController = controller;
                });
                controller.addJavaScriptHandler(
                    handlerName: "buttonState",
                    callback: (args) async {
                      webViewController = controller;

                      if (args[2][1] == 'CancelbuttonClicked') {
                        exitPaymentPage('paymentCancelled');
                      }

                      return args.reduce((curr, next) => curr + next);
                    });
              },
              onUpdateVisitedHistory: (InAppWebViewController controller,
                  Uri? uri, androidIsReload) async {
                if (uri.toString() == 'https://chapa.co') {
                  exitPaymentPage('paymentSuccessful');
                }
                if (uri.toString().contains('checkout/payment-receipt/')) {
                  await delay();
                  exitPaymentPage('paymentSuccessful');
                }
                controller.addJavaScriptHandler(
                    handlerName: "handlerFooWithArgs",
                    callback: (args) async {
                      webViewController = controller;
                      if (args[2][1] == 'failed') {
                        await delay();
                        exitPaymentPage('paymentFailed');
                      }
                      if (args[2][1] == 'success') {
                        await delay();
                        exitPaymentPage('paymentSuccessful');
                      }
                      return args.reduce((curr, next) => curr + next);
                    });

                controller.addJavaScriptHandler(
                    handlerName: "buttonState",
                    callback: (args) async {
                      webViewController = controller;

                      if (args[2][1] == 'CancelbuttonClicked') {
                        exitPaymentPage('paymentCancelled');
                      }

                      return args.reduce((curr, next) => curr + next);
                    });
              },
            ),
          ),
        ]),
      ),
    );
  }
}
