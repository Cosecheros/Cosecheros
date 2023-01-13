import 'package:cloud_firestore/cloud_firestore.dart';

class ResponseItem {
  String id;
  String type;
  String label;
  dynamic value;

  ResponseItem({this.id, this.type, this.label, this.value});

  ResponseItem.fromJson(Map json) {
    id = json['id'] ?? '';
    type = json['type'] ?? '';
    label = json['label'] ?? '';
    value = json['value'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        if (label != null) 'label': label,
        if (value != null) 'value': value,
      };

  String getValue() {
    final v = value;
    if (v is GeoPoint) {
      return "${v.latitude},${v.longitude}";
    }
    if (v is Timestamp) {
      return v.toDate().toIso8601String();
    }
    if (v is List) {
      return v.map((e) => e["label"]).join(",");
    }
    if (v is Map) {
      return v["label"];
    }
    return v.toString();
  }
}
