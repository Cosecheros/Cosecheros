import 'package:dynamic_forms/dynamic_forms.dart';

class Picture extends FormElement {
  static const String pathPropName = 'path';

  Property<String> get pathProperty => properties[pathPropName];

  set pathProperty(Property<String> path) =>
      registerProperty(pathPropName, path);

  String get path => pathProperty.value;

  Stream<String> get pathChanged => pathProperty.valueChanged;

  @override
  FormElement getInstance() {
    return Picture();
  }
}
