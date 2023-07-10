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
              androidOnPermissionRequest: (controller, origin, resources) async {
                return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
              },
              key: webViewKey,
              androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
                await Permission.camera.request();
                await Permission.microphone.request();
                return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
              },
              // onPermissionRequest: (controller, request) async {
              //   await Permission.camera.request();
              //   await Permission.microphone.request();
              //   debugPrint('request.resources: ${request.resources}');
              //   return PermissionResponse(
              //     resources: request.resources,
              //     action: PermissionResponseAction.GRANT,
              //   );
              // },
              initialUrlRequest: URLRequest(
                url: Uri.parse(widget.link ?? 'www.hyperverge.co'),
              ),
              // initialSettings: InAppWebViewSettings(
              //   javaScriptCanOpenWindowsAutomatically: true,
              //   supportMultipleWindows: true,
              //   useHybridComposition: true,
              //   mediaPlaybackRequiresUserGesture: false,
              //   allowsInlineMediaPlayback: true,
              // ),
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                    //javaScriptCanOpenWindowsAutomatically: true,
                    mediaPlaybackRequiresUserGesture: false,
                    // userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
                    userAgent: 'Dart/2.16 (dart:io)',
                  ),
                  ios: IOSInAppWebViewOptions(
                    allowsInlineMediaPlayback: true,
                  ),
                  android: AndroidInAppWebViewOptions(
                    // supportMultipleWindows: true,
                    useHybridComposition: true,
                  )
              ),
              // onWebViewCreated: (controller) {
              //   webViewController = controller;
              // },
              // onCreateWindow: (controller, createWindowAction) async {
              //   showDialog(
              //     context: context,
              //     builder: (context) {
              //       return WindowPopup(createWindowAction: createWindowAction);
              //     },
              //   );
              //   return true;
              // },
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
