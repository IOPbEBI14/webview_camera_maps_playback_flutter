import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyHomeView extends StatefulWidget {
  const MyHomeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomeViewState();
}

class _MyHomeViewState extends State<MyHomeView> {
  final inputController = TextEditingController();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool canGoBack = false, canGoForward = false;
  int canReload = 0;

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Future<WebViewController> webViewControllerFuture =
        _controller.future;
    double webProgress = 0;

    return FutureBuilder<WebViewController>(
        future: webViewControllerFuture,
        builder: (context, AsyncSnapshot<WebViewController> snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                backgroundColor: Colors.white,
                title: Row(
                  children: [
                    SizedBox(
                        width: 25,
                        child: IconButton(
                          autofocus: true,
                          color: canGoBack ? Colors.purple : null,
                          onPressed: () async {
                            if (canGoBack) {
                              await snapshot.data?.goBack();
                            }
                          },
                          icon: const Icon(Icons.arrow_circle_left_outlined),
                        )),
                    SizedBox(
                        width: 25,
                        child: IconButton(
                          color: canGoForward ? Colors.purple : null,
                          onPressed: () async {
                            if (canGoForward) {
                              await snapshot.data?.goForward();
                            }
                          },
                          icon: const Icon(Icons.arrow_circle_right_outlined),
                        )),
                    SizedBox(
                        width: 25,
                        child: IconButton(
                          color: Colors.purple,
                          onPressed: () async {
                            if (canReload == 1) await snapshot.data?.reload();
                          },
                          icon: Icon(canReload < 2
                              ? Icons.refresh_outlined
                              : Icons.stop),
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 250,
                            height: 40,
                            child: TextField(
                              onEditingComplete: () {
                                // _updateForm(inputController.value.text);
                                snapshot.data
                                    ?.loadUrl(inputController.value.text);
                                FocusScope.of(context).unfocus();
                              },
                              controller: inputController,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.search),
                                labelText: 'Go',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              webProgress < 1
                  ? SizedBox(
                      height: 5,
                      child: LinearProgressIndicator(
                        value: webProgress,
                        color: Colors.red,
                        backgroundColor: Colors.black,
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                // flex: 5,
                child: Center(
                  child: WebView(
                    //   initialUrl: siteUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    navigationDelegate: (NavigationRequest request) {
                      if (request.url.startsWith('https://www.youtube.com/')) {
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                    onProgress: (progress) => setState(() {
                      webProgress = progress / 100;
                    }),
                    gestureNavigationEnabled: true,
                    onPageStarted: (_) {
                      canReload = 2;
                      setState(() {});
                    },
                    onPageFinished: (_) async {
                      if (await snapshot.data!.canGoBack()) {
                        canGoBack = true;
                      } else {
                        canGoBack = false;
                      }
                      if (await snapshot.data!.canGoForward()) {
                        canGoForward = true;
                      } else {
                        canGoForward = false;
                      }
                      canReload = 1;
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          );
        });
  }
}
