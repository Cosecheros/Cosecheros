import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/data/current_user.dart';
import 'package:cosecheros/models/cosecha.dart';
import 'package:cosecheros/models/form_spec.dart';
import 'package:cosecheros/models/polygon.dart';
import 'package:cosecheros/models/tweet.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Database {
  static final Database instance = Database._privateConstructor();
  static final String _cosechasCollection = !kReleaseMode ? "prod_v2" : "dev";
  static final String _tuitCollection = "tweets_v3";
  static final String _polygonsCollection = "polygons";

  Database._privateConstructor();

  Query<Tweet> tuits(DateTime from) => FirebaseFirestore.instance
      .collection(_tuitCollection)
      //DateFormat('yyyy-MM-dd').format(from))
      .where("date", isGreaterThan: from)
      .withConverter<Tweet>(
        fromFirestore: (snapshot, _) => Tweet.fromSnapshot(snapshot),
        toFirestore: (tweet, _) => tweet.toJson(),
      );

  Query<Cosecha> cosechas(DateTime from) {
    print("Database: cosechas: from: $from");
    return FirebaseFirestore.instance
        .collection(_cosechasCollection)
        .where("timestamp", isGreaterThan: from)
        .orderBy("timestamp", descending: true)
        .withConverter<Cosecha>(
          fromFirestore: (snapshot, _) => Cosecha.fromSnapshot(snapshot),
          toFirestore: (cosecha, _) => cosecha.toJson(),
        );
  }

  Query<FormSpec> forms() =>
      FirebaseFirestore.instance.collection("forms").withConverter<FormSpec>(
            fromFirestore: (snapshot, _) => FormSpec.fromMap(snapshot.data()),
            toFirestore: (form, _) => form.toJson(),
          );

  DocumentReference<Tweet> tuit(String id) => FirebaseFirestore.instance
      .collection(_tuitCollection)
      .doc(id)
      .withConverter<Tweet>(
        fromFirestore: (snapshot, _) => Tweet.fromSnapshot(snapshot),
        toFirestore: (tweet, _) => tweet.toJson(),
      );

  Query<SMNPolygon> polygons(DateTime from) => FirebaseFirestore.instance
      .collection(_polygonsCollection)
      .where(FieldPath.documentId,
          isGreaterThan: DateFormat('yyyy-MM-dd').format(from))
      .withConverter<SMNPolygon>(
        fromFirestore: (snapshot, _) => SMNPolygon.fromSnapshot(snapshot),
        toFirestore: (it, _) => it.toJson(),
      );

  voteTuit(String id, int vote) async {
    print("Add vote $vote to tweet $id");
    await FirebaseFirestore.instance
        .collection(_tuitCollection)
        .doc(id)
        .update({"votes.${CurrentUser.instance.data.uid}": vote});
  }
}
