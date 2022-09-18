import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/models/cosecha.dart';
import 'package:cosecheros/models/form_spec.dart';
import 'package:cosecheros/models/tweet.dart';
import 'package:flutter/foundation.dart';

class Database {
  static final Database instance = Database._privateConstructor();

  Database._privateConstructor();

  Query<Tweet> tuits(DateTime from) => FirebaseFirestore.instance
      .collection(kReleaseMode ? "tweets_v3" : "tweets_v3")
      //DateFormat('yyyy-MM-dd').format(from))
      .where("date", isGreaterThan: from)
      .withConverter<Tweet>(
        fromFirestore: (snapshot, _) => Tweet.fromSnapshot(snapshot),
        toFirestore: (tweet, _) => tweet.toJson(),
      );

  Query<Cosecha> cosechas(DateTime from) => FirebaseFirestore.instance
      .collection(kReleaseMode ? "prod_v2" : "dev")
      .where("timestamp", isGreaterThan: from)
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
