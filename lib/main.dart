import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Parse SDK
  const String appId = 'JU3XU0JoeQbILPuSy0Fcg8BZlHMDtbYE4nC6TUa6';
  const String clientKey = 'xhLlmADAC16XzpS3php1XntxebsGIvTWtyz8989M';
  const String serverUrl = 'https://parseapi.back4app.com/';

  await Parse().initialize(appId, serverUrl, clientKey: clientKey, autoSendSessionId: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
