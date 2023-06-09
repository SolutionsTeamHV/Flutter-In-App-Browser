import 'package:flutter/material.dart';
import 'package:sample_web_view_app/web_view_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var linkController = TextEditingController();
  final buttonColor = const Color.fromRGBO(85, 78, 241, 1);
  final inputTextColor = const Color.fromRGBO(5, 5, 82, 0.8);
  final labelTextColor = const Color.fromRGBO(5, 5, 82, 0.4);
  final textFieldColor = const Color.fromRGBO(85, 78, 241, 0.15);
  final colorForOutline = const Color.fromRGBO(85, 78, 241, 0.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sample InAppWebView Application"),
        backgroundColor: buttonColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: linkController,
                cursorColor: buttonColor,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  color: inputTextColor,
                ),
                decoration: InputDecoration(
                  labelText: 'Enter the link',
                  labelStyle: TextStyle(
                    color: labelTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                  hintText: 'https://link-kyc.idv.hyperverge.co/...',
                  hintStyle: TextStyle(
                    color: labelTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textFieldColor, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorForOutline, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  focusColor: colorForOutline,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          WebViewScreen(link: linkController.text),
                    ),
                  );
                },
                height: 48.0,
                color: const Color.fromRGBO(85, 78, 241, 1),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.0,
                    color: Color.fromRGBO(85, 78, 241, 1),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: const Text(
                  'Open Link in Webview',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
