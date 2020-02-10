import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HarvestModel extends ChangeNotifier {

  DateTime dateTime;
  LatLng _latLng;

  Rain _rain = Rain.NA;
  HailSize _size = HailSize.NA;
  File _hail;
  File _hailStorm;

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

}

enum Rain { NA, before, during, after }
String rainToString(Rain rain) {
  switch (rain) {
    case Rain.NA:
      return "NS/NC";
    case Rain.before:
      return "Antes del granizo";
      break;
    case Rain.during:
      return "Durante el granizo";
      break;
    case Rain.after:
      return "Despues del granizo";
      break;
    default:
      return "";
      break;
  }
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