import 'package:crowd_management_agentic_ai/screen/splashPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Do not include AppCheck
  // await FirebaseAppCheck.instance.activate(); ← REMOVE this
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Firebase Flutter Demo',
      home: SplashPage(),
    );
  }
}