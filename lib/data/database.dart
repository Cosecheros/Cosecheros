import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/models/cosecha.dart';
import 'package:cosecheros/models/tweet.dart';
import 'package:cosecheros/shared/constants.dart';

class Database {
  static final Database instance = Database._privateConstructor();

  Database._privateConstructor();

  final tuitsRef = FirebaseFirestore.instance
      .collection("dev_tweets")
      .orderBy("date")
      .withConverter<Tweet>(
        fromFirestore: (snapshot, _) => Tweet.fromSnapshot(snapshot),
        toFirestore: (tweet, _) => tweet.toJson(),
      );

  final cosechasRef = FirebaseFirestore.instance
      .collection(Constants.collection)
      .where("timestamp",
          isGreaterThan: DateTime.now().subtract(Duration(days: 30)))
      .orderBy("timestamp", descending: true)
      .withConverter<Cosecha>(
        fromFirestore: (snapshot, _) => Cosecha.fromSnapshot(snapshot),
        toFirestore: (cosecha, _) => cosecha.toJson(),
      );
}
