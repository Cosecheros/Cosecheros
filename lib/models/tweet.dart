import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  String id;
  DateTime date;
  String event_type;
  String screen_name;
  String text;

  // nullable
  GeoPoint tw_place;
  List<Place> places;

  static Tweet fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    Tweet record = Tweet();
    record.id = doc.id;

    final data = doc.data();
    record.date = data["date"].toDate() ?? DateTime.now();
    record.event_type = data["event_type"];
    record.screen_name = data["screen_name"];
    record.text = data["text"];

    record.tw_place = data["tw_place"];

    final places = data["places"];
    if (places is List) {
      record.places = places.map((e) => Place.fromJson(e)).toList();
    }
    return record;
  }

  toJson() {
    // todo
  }
}

class Place {
  String alias;
  double lat;
  double lon;

  static Place fromJson(Map<String, dynamic> json) {
    Place record = Place();
    record.alias = json["alias"];
    record.lat = json["lat"];
    record.lon = json["lon"];
    return record;
  }
}