import 'package:dynamic_forms/dynamic_forms.dart';

class Picture extends FormElement {
  static const String pathPropName = 'path';
  static const String labelPropertyName = 'label';

  String url;

  String get label => labelProperty.value;
  Stream<String> get labelChanged => labelProperty.valueChanged;
  Property<String> get labelProperty =>
      properties[labelPropertyName] as Property<String>;
  set labelProperty(Property<String> value) =>
      registerProperty(labelPropertyName, value);

  String get path => pathProperty.value;
  Stream<String> get pathChanged => pathProperty.valueChanged;
  Property<String> get pathProperty => properties[pathPropName];
  set pathProperty(Property<String> path) =>
      registerProperty(pathPropName, path);

  @override
  FormElement getInstance() {
    return Picture();
  }
}
