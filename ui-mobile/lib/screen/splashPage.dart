// ignore_for_file: use_build_context_synchronously

import 'package:crowd_management_agentic_ai/screen/login.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    gologin();
    super.initState();
  }

  gologin() async {
    await Future.delayed(const Duration(milliseconds: 4200), () {});

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            const LoginPage(title: 'Drishti Login'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/render.gif',
              height: 400,
            ),
          ],
        ),
      ),
    );
  }
}
