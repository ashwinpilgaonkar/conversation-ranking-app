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
    super.initState();

    FirebaseFirestore.instance
        .collection('conversations')
        .doc(widget.xpeerId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // get the data from this document snapshot
        var data = documentSnapshot.data() as Map<String, dynamic>;

        double result = 0;
        double r1 = 0;
        double r2 = 0;

        if (data['rank1'] != null) {
          r1 = data['rank1'];
        } else {
          r1 = r2;
        }

        if (data['rank2'] != null) {
          r2 = data['rank2'];
        } else {
          r2 = r1;
        }

        result = (r1 + r2) / 2;

        setState(() {
          _avg_rating = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rating")),
      body: Center(
          child: Text("The avarage rating of this chat is ${_avg_rating}")),
    );
  }
}
