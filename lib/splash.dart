import 'package:fanchat_app/all_logins.dart';
import 'package:fanchat_app/dashboard.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateHome();
    // this will run at the first time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/logo.png"), fit: BoxFit.fill)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: const Text("Welcome to the App"),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateHome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    // after this delay
    // connect user to auth state stream
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, userSnapshot) {
                if (userSnapshot.hasData) {
                  return const DashBoard();
                } else {
                  return AllLogins();
                }
              }),
        ));
  }
}
