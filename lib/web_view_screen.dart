import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class WebViewScreen extends StatefulWidget {
  final String? link;

  const WebViewScreen({
    this.link,
    Key? key,
  }) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreen();
}

class _WebViewScreen extends State<WebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webview Popup window'),
        backgroundColor: const Color.fromRGBO(85, 78, 241, 1),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: InAppWebView(
              key: webViewKey,
              onPermissionRequest: (controller, request) async {
                await Permission.camera.request();
                await Permission.microphone.request();
                debugPrint('request.resources: ${request.resources}');
                return PermissionResponse(
                  resources: request.resources,
                  action: PermissionResponseAction.GRANT,
                );
              },
              initialUrlRequest: URLRequest(
                url: WebUri(widget.link ?? 'www.hyperverge.co'),
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptCanOpenWindowsAutomatically: true,
                supportMultipleWindows: true,
                useHybridComposition: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
              ),
              /*initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    javaScriptCanOpenWindowsAutomatically: true,
                    mediaPlaybackRequiresUserGesture: false,
                  ),
                  ios: IOSInAppWebViewOptions(
                    allowsInlineMediaPlayback: true,
                  ),
                  android: AndroidInAppWebViewOptions(
                    supportMultipleWindows: true,
                  )
              ),*/
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onCreateWindow: (controller, createWindowAction) async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return WindowPopup(createWindowAction: createWindowAction);
                  },
                );
                return true;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WindowPopup extends StatefulWidget {
  final CreateWindowAction createWindowAction;

  const WindowPopup({Key? key, required this.createWindowAction})
      : super(key: key);

  @override
  State<WindowPopup> createState() => _WindowPopupState();
}

class _WindowPopupState extends State<WindowPopup> {
  String title = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(title,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close))
                  ],
                ),
                Expanded(
                  child: InAppWebView(
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    },
                    windowId: widget.createWindowAction.windowId,
                    onTitleChanged: (controller, title) {
                      setState(() {
                        this.title = title ?? '';
                      });
                    },
                    onCloseWindow: (controller) {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            height: 75,
          ),
        ],
      ),
    );
  }
}
