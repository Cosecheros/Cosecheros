import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_transform/stream_transform.dart';

enum UserStatus { unlogged, without_type, ready }
enum UserType { ciudadano, agricultor }

class UserData {
  final String name;
  final String photo;
  final String uid;
  final UserType type;
  final bool isAnonymous;

  UserData({this.name, this.photo, this.uid, this.type, this.isAnonymous});
}

class CurrentUser {
  CurrentUser._privateConstructor();

  static final CurrentUser instance = CurrentUser._privateConstructor();

  UserData data;

  Stream<UserStatus> updates() {
    return FirebaseAuth.instance
        .authStateChanges()
        .switchMap((event) => onStateChange(event));
  }

  Stream<UserStatus> onStateChange(User user) async* {
    print("onStateChange: $user");
    if (user == null) {
      data = null;
      yield UserStatus.unlogged;
    } else {
      yield* FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .snapshots()
          .map((event) => onUserDocChange(user, event));
    }
  }

  UserStatus onUserDocChange(User user, DocumentSnapshot doc) {
    print("onUserDocChange: ${doc.data()}");
    if (doc.exists) {
      if (doc.data()["type"] != null) {
        data = userDataFrom(user, doc.data());
        return UserStatus.ready;
      } else {
        data = userDataFrom(user, doc.data());
        return UserStatus.without_type;
      }
    } else {
      data = userDataFrom(user, null);
      return UserStatus.without_type;
    }
  }

  UserData userDataFrom(User user, Map<String, dynamic> doc) {
    // Pensé que eras chevere Dart
    // https://stackoverflow.com/a/44060511
    String _type = doc == null ? null : doc["type"];
    UserType type = _type == null
        ? null
        : UserType.values
            .firstWhere((e) => e.toString() == 'UserType.' + _type);

    return UserData(
      name: user?.displayName,
      photo: user?.photoURL,
      uid: user?.uid,
      type: type,
      isAnonymous: user?.isAnonymous,
    );
  }
}
