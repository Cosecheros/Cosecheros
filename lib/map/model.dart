import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Cosecha {
  String id;
  String form;
  DateTime timestamp;
  LatLng latLng;
  String username;
  String alias;
  Map<String, dynamic> raw;

  static Cosecha fromSnapshot(QueryDocumentSnapshot doc) {
    Cosecha result = Cosecha();

    var data = doc.data();

    result.id = doc.id;
    result.form = data['form'];
    result.timestamp = data['timestamp']?.toDate() ?? DateTime.now();

    GeoPoint geo = data['geo'];
    result.latLng = LatLng(geo.latitude, geo.longitude);

    result.username = data['username'] ?? "un héroe anónimo";

    result.alias = data['form_alias'] ?? "Una cosecha";

    result.raw = data;
    return result;
  }
}