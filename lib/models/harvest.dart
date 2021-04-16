import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HarvestModel extends ChangeNotifier {
  DateTime dateTime;
  LatLng _latLng;

  Rain _rain = Rain.NA;
  HailSize _size = HailSize.NA;
  File _hailStorm;
  File _hail;

  String stormThumb;
  String hailThumb;

  get latLng => _latLng;
  set latLng(LatLng latLng) {
    this._latLng = latLng;
    notifyListeners();
  }

  get geoPoint => GeoPoint(_latLng.latitude, _latLng.longitude);
  set geoPoint(GeoPoint geoPoint) {
    this._latLng = LatLng(geoPoint.latitude, geoPoint.longitude);
  }

  get rain => _rain;
  set rain(Rain rain) {
    this._rain = rain;
    notifyListeners();
  }

  get size => _size;
  set size(HailSize size) {
    this._size = size;
    notifyListeners();
  }

  get hail => _hail;
  set hail(File hail) {
    this._hail = hail;
    notifyListeners();
  }

  get hailStorm => _hailStorm;
  set hailStorm(File file) {
    this._hailStorm = file;
    this.dateTime = file.lastModifiedSync();
    notifyListeners();
  }

  Map<String, dynamic> toMap() => {
        'timestamp': FieldValue.serverTimestamp(),
        'date': dateTime,
        'geo': geoPoint,
        'lluvia': rainToString(rain),
        //'tamaño': sizeToString(size),
      };

  static HarvestModel fromSnapshot(QueryDocumentSnapshot doc) {
    HarvestModel model = HarvestModel();
    model.dateTime = doc.data()['date'].toDate();
    model.geoPoint = doc.data()['geo'];
    model._rain = stringToRain(doc.data()['lluvia']);

    model.stormThumb = doc.data()['granizada_thumb'];

    if (model.stormThumb == 'ready') {
      model.stormThumb = null;
      FirebaseStorage.instance
          .ref()
          .child("cosechas/thumbs/${doc.id}-granizada_500x500.jpg")
          .getDownloadURL()
          .then((url) => FirebaseFirestore.instance
                  .doc("cosechas/${doc.id}")
                  .update({
                'granizada_thumb': url,
              }));
    }

    model.hailThumb = doc.data()['granizo_thumb'];

    if (model.hailThumb == 'ready') {
      model.hailThumb = null;
      FirebaseStorage.instance
          .ref()
          .child("cosechas/thumbs/${doc.id}-granizo_500x500.jpg")
          .getDownloadURL()
          .then((url) => FirebaseFirestore.instance
                  .doc("cosechas/${doc.id}")
                  .update({
                'granizo_thumb': url,
              }));
    }

    return model;
  }
}

enum Rain { NA, before, during, after }
const List<String> RainStrings = [
  "NS/NC",
  "Antes del granizo",
  "Durante el granizo",
  "Despues del granizo"
];
String rainToString(Rain rain) {
  return RainStrings[Rain.values.indexOf(rain)];
}

Rain stringToRain(String string) {
  return Rain.values[RainStrings.indexOf(string)];
}

enum HailSize { NA, small, medium, big }
String hailSizeToString(HailSize size) {
  switch (size) {
    case HailSize.NA:
      return "NS/NC";
      break;
    case HailSize.small:
      return "Pequeño";
      break;
    case HailSize.medium:
      return "Mediano";
      break;
    case HailSize.big:
      return "Grande";
      break;
    default:
      return "";
      break;
  }
}
