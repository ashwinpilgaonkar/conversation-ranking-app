import 'package:fanchat_app/auth_class.dart';
import 'package:fanchat_app/login_with_email_password.dart';
import 'package:flutter/material.dart';
import 'package:fanchat_app/register.dart';

class AllLogins extends StatefulWidget {
  AllLogins({Key? key}) : super(key: key);

  @override
  _AllLoginsState createState() => _AllLoginsState();
}

class _AllLoginsState extends State<AllLogins> {
  var fireAuth = FireAuth();

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("All Login Methods"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // NEW REGISTRATION
              FractionallySizedBox(
                widthFactor: 0.7,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      );
                    },
                    child: const Text("New User Registration")),
              ),

              const Divider(
                color: Colors.deepPurple,
                height: 20,
                thickness: 1,
                indent: 50,
                endIndent: 50,
              ),

              // EMAIL AND PASSWORD
              FractionallySizedBox(
                widthFactor: 0.7,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: const Text("Login With Email and Password")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
