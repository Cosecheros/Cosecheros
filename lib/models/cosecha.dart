import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/models/response_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Cosecha {
  String id;
  String form;
  DateTime timestamp;
  LatLng latLng;
  String username;
  String alias;
  List<ResponseItem> payload;

  static Cosecha fromSnapshot(QueryDocumentSnapshot doc) {
    Cosecha result = Cosecha();
    // print("Cosecha: fromSnapshot >>>
    // print(doc.data());
    // print("Cosecha: fromSnapshot <<<");

    var data = doc.data();

    result.id = doc.id;
    result.form = data['form_id'];
    result.alias = data['form_alias'] ?? "Una cosecha";
    result.username = data['username'] ?? "un héroe anónimo";
    result.timestamp = data['timestamp']?.toDate() ?? DateTime.now();

    final payload = data['payload'];
    if (payload is List) {
      result.payload = payload.map((e) => ResponseItem.fromJson(e)).toList();

      print("Cosecha: payload: " + result.payload.length.toString());

      final geo = result.payload.singleWhere(
        (element) => element.type == 'geo_point',
        orElse: () => null,
      );

      if (geo != null) {
        final geoPoint = geo.value as GeoPoint;
        result.latLng = LatLng(geoPoint.latitude, geoPoint.longitude);
      }
    }
    return result;
  }
}
