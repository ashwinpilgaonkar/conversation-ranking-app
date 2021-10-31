import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class peerInfo extends StatefulWidget {
  peerInfo({Key? key, required this.xpeerId}) : super(key: key);

  final String xpeerId;

  @override
  _peerInfoState createState() => _peerInfoState();
}

class _peerInfoState extends State<peerInfo> {
  double _avg_rating = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("xpeerId : " + widget.xpeerId);

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.xpeerId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // get the data from this document snapshot
        var data = documentSnapshot.data() as Map<String, dynamic>;
        print(data['ranks']);
        var arr = data['ranks'];
        // update the arr
        double sum = 0;
        for (int i = 0; i < arr.length; i++) {
          var x = arr[i];
          sum = sum + x;
        }

        double result = sum / arr.length;

        print("result: ${result}");

        setState(() {
          _avg_rating = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("User Info"),
          centerTitle: true),
      body: Center(child: Text("Avarage Rating of this user ${_avg_rating}")),
    );
  }
}
