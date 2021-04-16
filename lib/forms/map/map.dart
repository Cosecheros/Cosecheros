import 'dart:ui';

import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter/foundation.dart';

@immutable
class GeoPos {
  const GeoPos(this.latitude, this.longitude)
      : assert(latitude >= -90 && latitude <= 90),
        assert(longitude >= -180 && longitude <= 180);

  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) =>
      other is GeoPos &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => hashValues(latitude, longitude);

  @override
  String toString() {
    return '$latitude,$longitude';
  }
}

class Map extends FormElement {
  static const String pointPropName = 'point';

  Property<GeoPos> get pointProperty => properties[pointPropName];

  set pointProperty(Property<GeoPos> point) =>
      registerProperty(pointPropName, point);

  GeoPos get point => pointProperty.value;

  Stream<GeoPos> get pointChanged => pointProperty.valueChanged;

  @override
  FormElement getInstance() {
    return Map();
  }
}
