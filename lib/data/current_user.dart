import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/models/geo_pos.dart';
import 'package:cosecheros/shared/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stream_transform/stream_transform.dart';

class CurrentUser {
  static final CurrentUser instance = CurrentUser._privateConstructor();

  CurrentUser._privateConstructor();

  UserData data;

  Stream<UserStatus> updates() {
    return FirebaseAuth.instance
        .authStateChanges()
        .switchMap((event) => onFirebaseAuthChange(event));
  }

  Stream<UserStatus> onFirebaseAuthChange(User user) async* {
    print("onFirebaseAuthChange: uid=${user?.uid}");
    if (user == null) {
      data = null;
      yield UserStatus.unlogged;
    } else {
      yield* FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .snapshots()
          .distinct(
              (eventA, eventB) => eventA.exists && eventA.data()["type"] == eventB.data()["type"])
          .map((event) => onUserDocChange(user, event));
    }
  }

  UserStatus onUserDocChange(User user, DocumentSnapshot doc) {
    print("onUserDocChange: exist=${doc.exists}, ${doc.data()}");
    if (!doc.exists) {
      data = userDataFrom(user, null);
      return UserStatus.without_type;
    } else {
      data = userDataFrom(user, doc.data());
      if (doc.get("type") == null) {
        return UserStatus.without_type;
      } else {
        return UserStatus.ready;
      }
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

  Future<void> setupToken() async {
    // Get the token each time the application loads
    String token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await _saveToken(token);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh
        .listen(_saveToken);
  }
  
  Future<void> _saveToken(String token) async {
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
