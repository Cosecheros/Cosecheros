import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/models/cosecha.dart';
import 'package:cosecheros/models/form_spec.dart';
import 'package:cosecheros/models/tweet.dart';
import 'package:flutter/foundation.dart';

class Database {
  static final Database instance = Database._privateConstructor();

  Database._privateConstructor();

  Query<Tweet> tuits(DateTime from) => FirebaseFirestore.instance
      .collection(kReleaseMode ? "tweets_v2" : "tweets_v2")
      .where("date",
          isGreaterThan: from) //DateFormat('yyyy-MM-dd').format(from))
      .withConverter<Tweet>(
        fromFirestore: (snapshot, _) => Tweet.fromSnapshot(snapshot),
        toFirestore: (tweet, _) => tweet.toJson(),
      );

  final cosechasRef = FirebaseFirestore.instance
      .collection(kReleaseMode ? "prod_v2" : "dev")
      .where("timestamp",
          isGreaterThan: DateTime.now().subtract(Duration(days: 30)))
      .orderBy("timestamp", descending: true)
      .withConverter<Cosecha>(
        fromFirestore: (snapshot, _) => Cosecha.fromSnapshot(snapshot),
        toFirestore: (cosecha, _) => cosecha.toJson(),
      );

  Query<FormSpec> forms() =>
      FirebaseFirestore.instance.collection("forms").withConverter<FormSpec>(
            fromFirestore: (snapshot, _) => FormSpec.fromMap(snapshot.data()),
            toFirestore: (form, _) => form.toJson(),
          );
}
