import 'package:crowd_management_agentic_ai/screen/dashboard.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;

  @override
  Widget build(BuildContext context) {
    final emailIdController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/one.jpg"), fit: BoxFit.cover)),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Project Drishti',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.dmSerifDisplay(
                      fontSize: 30, fontWeight: FontWeight.bold),
                  // style: TextStyle(
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 30,
                  // ),
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: emailIdController,
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : "Please enter a valid email",
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      maxLines: 1,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: 'Enter your password',
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print("CLICKED!");

                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailIdController.text,
                                password: passwordController.text)
                            .then((value) => {
                              print(value.user?.uid),
                          value.user?.uid == "iBkTO5mQEIZBDoKBvv1KcqQXV4E2" ?
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Dashboard())) : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const Dashboard()))
                                })
                            .catchError((onError) => {print(onError)});
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
