import 'dart:io';
import 'dart:typed_data';

import 'package:fanchat_app/auth_class.dart';
import 'package:fanchat_app/dashboard.dart';
import 'package:fanchat_app/login_with_email_password.dart';
import 'package:fanchat_app/splash.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:math';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FanPage",
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("Register"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: const RegisterUserForm(),
      ),
    );
  }
}

class RegisterUserForm extends StatefulWidget {
  const RegisterUserForm({Key? key}) : super(key: key);

  @override
  _RegisterUserFormState createState() => _RegisterUserFormState();
}

class _RegisterUserFormState extends State<RegisterUserForm> {
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  // email address, password, name, picture, bio, hometown, age.

  var _email = "";
  var _password = "";
  var _firstName = "";
  var _lastName = "";
  var userCredentialsObj;
  var isImageUploaded = false;
  // new code
  var _image;
  var blobData;

  // create cloud storage instance
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  var imageURL;

  Future<Uint8List> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File audioFile = new File.fromUri(myUri);
    late Uint8List bytes;
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return bytes;
  }

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      try {
        _image = File(image!.path);
        isImageUploaded = true;
      } catch (e) {
        print(e);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Register()));
      }

      // _image = File(image!.path);
      // isImageUploaded = true;
    });
    try {
      Uint8List audioByte;
      String myPath = image!.path;
      _readFileByte(myPath).then((bytesData) {
        audioByte = bytesData;
        //do your task here
        setState(() {
          blobData = audioByte;
        });
      });
    } catch (e) {
      // if path invalid or not able to read
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(
              children: [
                // user display picture
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage:
                      imageURL != null ? NetworkImage(imageURL) : null,
                  // backgroundColor: imageURL == null
                  //     ? Colors.brown.shade800
                  //     : Colors.transparent,
                ),

                // text field for first name
                TextFormField(
                  decoration: const InputDecoration(hintText: "First Name"),
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,

                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      _firstName = val;
                    });
                  },
                ),

                // text field for last name
                TextFormField(
                  decoration: const InputDecoration(hintText: "Last Name"),
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,

                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      _lastName = val;
                    });
                  },
                ),

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
                      _email = val;
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
                      _password = val;
                    });
                  },
                ),

                // icon button for file upload
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple),
                    ),
                    onPressed: () async {
                      // create instance of firebase storage
                      firebase_storage.FirebaseStorage storage =
                          firebase_storage.FirebaseStorage.instance;
                      final _picker = ImagePicker();
                      PickedFile image;
                      // generate some random number
                      Random random = Random();
                      int randomNumber = random.nextInt(100000);
                      try {
                        image = (await _picker.getImage(
                            source: ImageSource.gallery))!;
                        var file = File(image.path);

                        if (image != null) {
                          // proceed
                          var snapShot = await storage
                              .ref()
                              .child("display-pictures/$randomNumber")
                              .putFile(file);
                          var downloadURL = await snapShot.ref.getDownloadURL();

                          setState(() {
                            imageURL = downloadURL;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            FireAuth.customSnackBar(
                              content: "NO Path received for image.",
                            ),
                          );
                        }
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          FireAuth.customSnackBar(
                            content:
                                "Couldn't select image from gallery. Please try again.",
                          ),
                        );
                      }
                    },
                    child: const Text("Upload Your Picture"),
                  ),
                ),

                // this is padding for register button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple),
                    ),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("checking.. please wait..")),
                        );

                        // call the firebase function
                        User? user = await fireAuth.registerUsingEmailPassword(
                            email: _email,
                            password: _password,
                            context: context);

                        if (user != null) {
                          // registration successful
                          // if no error occurred
                          // finally insert data into firestore
                          // create collection instance in the code
                          CollectionReference users =
                              FirebaseFirestore.instance.collection("users");

                          print("user is not null. save data into firestore.");

                          users
                              .doc(user.uid)
                              .set({
                                'firstName': _firstName,
                                'lastName': _lastName,
                                'email': _email,
                                'password': _password,
                                // 'bio': _bio,
                                // 'hometown': _hometown,
                                // 'age': _age,123456
                                // 'avatar': Blob(blobData),
                                'imageURL': imageURL,
                                'createdAt': DateTime.now(),
                                'ranks': []
                              })
                              .then((value) => {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text('Congrats!'),
                                              content: const Text(
                                                  'Your Registration is successful.'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => {
                                                    // finally navigate after login
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const DashBoard()))
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ))
                                  })
                              .catchError((error) => {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title:
                                                  const Text('Error Occurred!'),
                                              content: const Text(
                                                  'Error in saving your data to firestore. Please try again.'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => {
                                                    // finally navigate after login
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const SplashScreen()))
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ))
                                  });
                        }
                      }
                    },
                    child: const Text('Register'),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text("Already Registered?",
                      style: TextStyle(
                        color: Colors.purple,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                        decorationThickness: 2,
                      )),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
