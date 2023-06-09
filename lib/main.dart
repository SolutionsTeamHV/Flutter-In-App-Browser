import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      kDebugMode &&
      defaultTargetPlatform == TargetPlatform.android) {
    // await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  runApp(const SampleWebViewApp());
}

class SampleWebViewApp extends StatelessWidget {
  const SampleWebViewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
