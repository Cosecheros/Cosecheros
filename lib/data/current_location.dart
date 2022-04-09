import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/models/geo_pos.dart';
import 'package:cosecheros/shared/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentLocation {
  static final CurrentLocation instance = CurrentLocation._privateConstructor();

  CurrentLocation._privateConstructor();

  void saveUserPosition(GeoPos pos) async {
    print("saveUserPosition: $pos");
    var update = {
      "position": {
        "pos": geoPoinFromGeoPos(pos),
        "timestamp": DateTime.now()
      }
    };

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set(update, SetOptions(merge: true));
  }
}
