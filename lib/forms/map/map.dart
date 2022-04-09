import 'package:dynamic_forms/dynamic_forms.dart';

import '../../models/geo_pos.dart';

class Map extends FormElement {
  static const String pointPropName = 'point';

  GeoPos get point => pointProperty.value;

  Stream<GeoPos> get pointChanged => pointProperty.valueChanged;

  Property<GeoPos> get pointProperty => properties[pointPropName];

  set pointProperty(Property<GeoPos> point) =>
      registerProperty(pointPropName, point);

  @override
  FormElement getInstance() {
    return Map();
  }
}
