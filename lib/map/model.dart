import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Cosecha {
  String id;
  DateTime timestamp;
  LatLng latLng;

  static Cosecha fromSnapshot(QueryDocumentSnapshot doc) {
    Cosecha result = Cosecha();

    result.id = doc.id;
    result.timestamp = doc.data()['timestamp']?.toDate() ?? DateTime.now();

    GeoPoint geo = doc.data()['geo'];
    result.latLng = LatLng(geo.latitude, geo.longitude);
    return result;
  }
}