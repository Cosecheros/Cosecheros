import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/models/geo_pos.dart';

class SMNPolygon {
  String id;
  List<GeoPos> polygon;

  static SMNPolygon fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    SMNPolygon record = SMNPolygon();
    record.id = doc.id;
    final polygon = doc.data()["polygon"];
    if (polygon != null && polygon is List) {
      record.polygon = polygon.map((e) => GeoPos.fromJson(e)).toList();
    }
    return record;
  }

  toJson() {}

}
