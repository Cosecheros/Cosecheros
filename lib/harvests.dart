import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Harvests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('cosechas').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loaarstding...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['timestamp'].toDate().toIso8601String()),
                  subtitle: new Text(document['lluvia']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}