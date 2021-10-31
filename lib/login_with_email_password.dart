import 'package:fanchat_app/auth_class.dart';
import 'package:fanchat_app/dashboard.dart';
import 'package:fanchat_app/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  var _email = "";
  var _password = "";
  var userCredentialsObj;
  var _role = "";
  // create firebae instance
  CollectionReference users =
      FirebaseFirestore.instance.collection("hw2_users");

  var fireAuth = FireAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Login"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // text field for email
                TextFormField(
                  decoration: const InputDecoration(hintText: "Email"),
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.emailAddress,

                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      _email = val.trim();
                    });
                  },
                ),

                // text field for password
                TextFormField(
                  decoration: const InputDecoration(hintText: "Password"),
                  textAlign: TextAlign.start,

                  obscureText: true,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },

                  onChanged: (val) {
                    setState(() {
                      _password = val.trim();
                    });
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.purple.shade700),
                    ),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      // print(_formKey.currentState);
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("checking.. please wait..")),
                        );

                        // signin with email and password
                        User? user = await fireAuth.signInUsingEmailPassword(
                            email: _email,
                            password: _password,
                            context: context);

                        if (user != null) {
                          // check if user is ADMIN OR CUSTOMER
                          FirebaseFirestore.instance
                              .collection('hw2_users')
                              .where('email', isEqualTo: _email)
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            for (var i = 0;
                                i < querySnapshot.docs.length;
                                i++) {
                              var doc = querySnapshot.docs[i];

                              if (doc["role"].toString() == "ADMIN") {
                                // print("ADMIN FOUND");
                                _role = doc["role"].toString();
                                break;
                              }
                            }

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const DashBoard()));
                          });
                        }
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()));
                  },
                  child: const Text("Not a User? Register here!",
                      style: TextStyle(
                        color: Colors.purple,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                        decorationThickness: 2,
                      )),
                )
              ],
            ),
          )),
    );
  }
}
