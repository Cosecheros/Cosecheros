import 'package:dynamic_forms/dynamic_forms.dart';

class Info extends FormElement {
  static const String titlePropName = 'title';
  static const String subtitlePropName = 'subtitle';
  static const String imgPropName = 'img';

  Property<String> get titleProperty => properties[titlePropName];
  set titleProperty(Property<String> value) =>
      registerProperty(titlePropName, value);
  String get title => titleProperty.value;
  Stream<String> get titleChanged => titleProperty.valueChanged;


  Property<String> get subtitleProperty => properties[subtitlePropName];
  set subtitleProperty(Property<String> value) =>
      registerProperty(subtitlePropName, value);
  String get subtitle => subtitleProperty.value;
  Stream<String> get subtitleChanged => subtitleProperty.valueChanged;

  Property<String> get imgProperty => properties[imgPropName];
  set imgProperty(Property<String> value) =>
      registerProperty(imgPropName, value);
  String get img => imgProperty.value;
  Stream<String> get imgChanged => imgProperty.valueChanged;

  @override
  FormElement getInstance() {
    return Info();
  }
}
