import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../provider/web_provider.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({super.key});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  InAppWebViewController? inAppWebViewController;
  PullToRefreshController? pullToRefreshController;
  String _selectedEngine = "Google"; 

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        WebUri? webUri = await inAppWebViewController?.getUrl();
        inAppWebViewController?.loadUrl(urlRequest: URLRequest(url: webUri));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String url = "${ModalRoute.of(context)?.settings.arguments}";

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: Text(
          "Web Browser",
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              inAppWebViewController?.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(url)),
            onWebViewCreated: (controller) {
              inAppWebViewController = controller;
            },
            onLoadStop: (controller, url) {
              pullToRefreshController?.endRefreshing();
            },
            onProgressChanged: (controller, progress) {
              if (progress >= 100) {
                pullToRefreshController?.endRefreshing();
              }
              Provider.of<WebProvider>(context, listen: false)
                  .onChangeProgress(progress);
            },
            pullToRefreshController: pullToRefreshController,
          ),
          Consumer<WebProvider>(
            builder: (context, value, child) {
              return value.progress < 1
                  ? Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: value.progress,
                  color: Colors.blueAccent,
                  backgroundColor: Colors.grey[300],
                ),
              )
                  : SizedBox.shrink();
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 6,
                shadowColor: Colors.grey.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          inAppWebViewController?.goBack();
                        },
                        icon: Icon(Icons.arrow_back_ios,
                            color: Colors.blueAccent),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            DropdownButton<String>(
                              value: _selectedEngine,
                              items: [
                                DropdownMenuItem(
                                  value: "Google",
                                  child: Text("Google"),
                                ),
                                DropdownMenuItem(
                                  value: "Yahoo",
                                  child: Text("Yahoo"),
                                ),
                                DropdownMenuItem(
                                  value: "Bing",
                                  child: Text("Bing"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedEngine = value ?? "Google";
                                });
                              },
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Search or enter URL",
                                  border: InputBorder.none,
                                  contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                                ),
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
                                  String searchUrl;
                                  switch (_selectedEngine) {
                                    case "Yahoo":
                                      searchUrl = "https://www.yahoo.com/search?q=$value";
                                      break;
                                    case "Bing":
                                      searchUrl =
                                      "https://www.bing.com/search?q=$value";
                                      break;
                                    default:
                                      searchUrl =
                                      "https://www.google.com/search?q=$value";
                                  }
                                  inAppWebViewController?.loadUrl(
                                      urlRequest: URLRequest(
                                          url: WebUri(searchUrl)));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          inAppWebViewController?.goForward();
                        },
                        icon: Icon(Icons.arrow_forward_ios,
                            color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
