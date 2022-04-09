import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/models/geo_pos.dart';
import 'package:cosecheros/shared/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_transform/stream_transform.dart';

class CurrentUser {
  static final CurrentUser instance = CurrentUser._privateConstructor();

  CurrentUser._privateConstructor();

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
          .distinct(
              (eventA, eventB) => eventA.get("type") == eventB.get("type"))
          .map((event) => onUserDocChange(user, event));
    }
  }

  UserStatus onUserDocChange(User user, DocumentSnapshot doc) {
    print("onUserDocChange: ${doc.data()}");
    if (doc.exists) {
      if (doc.get("type") != null) {
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

  Future<void> saveType(UserType selected) async {
    print("setUserType: $selected");
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({"type": selected.id()});
  }

  Future<void> savePosition(GeoPos pos) async {
    print("saveUserPosition: $pos");
    var update = {
      "position": {
        "pos": geoPoinFromGeoPos(pos),
        "timestamp": DateTime.now(),
      }
    };

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set(update, SetOptions(merge: true));
  }

  Future<void> saveToken(String token) async {
    print("saveToken: $token");
    var update = {
      'tokens': FieldValue.arrayUnion([token])
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update(update);
  }
}

class UserData {
  final String name;
  final String photo;
  final String uid;
  final UserType type;
  final bool isAnonymous;

  UserData({this.name, this.photo, this.uid, this.type, this.isAnonymous});
}

enum UserStatus { unlogged, without_type, ready }

enum UserType { ciudadano, productor }

extension UserTypeToString on UserType {
  String id() {
    return toString().split('.').last;
  }
}
