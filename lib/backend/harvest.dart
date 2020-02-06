import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class HarvestModel extends ChangeNotifier {

  DateTime dateTime;
  GeoPoint _geoPoint;

  Rain _rain = Rain.NA;
  HailSize _size = HailSize.NA;
  File _hail;
  File _hailStorm;

  get geoPoint => _geoPoint;
  set geoPoint(GeoPoint geoPoint) {
    this._geoPoint = geoPoint;
    notifyListeners();
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
    'timestamp': dateTime,
    'geo': _geoPoint,
    'lluvia': rain.toString(),
    'tamaño': size.toString(),
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