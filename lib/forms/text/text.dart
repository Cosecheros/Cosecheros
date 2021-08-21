import 'package:flutter/widgets.dart';
import 'package:dynamic_forms/dynamic_forms.dart';

class TextElement extends FormElement {
  static const String inputTypePropertyName = 'inputType';
  static const String labelPropertyName = 'label';
  static const String inputLabelPropertyName = 'inputLabel';
  static const String hintPropertyName = 'hint';
  static const String helpPropertyName = 'help';
  static const String validationsPropertyName = 'validations';
  static const String valuePropertyName = 'value';

  Property<TextInputType> get inputTypeProperty =>
      properties[inputTypePropertyName] as Property<TextInputType>;
  set inputTypeProperty(Property<TextInputType> value) =>
      registerProperty(inputTypePropertyName, value);
  TextInputType get inputType => inputTypeProperty.value;
  Stream<TextInputType> get inputTypeChanged => inputTypeProperty.valueChanged;

  Property<String> get labelProperty =>
      properties[labelPropertyName] as Property<String>;
  set labelProperty(Property<String> value) =>
      registerProperty(labelPropertyName, value);
  String get label => labelProperty.value;
  Stream<String> get labelChanged => labelProperty.valueChanged;

  Property<String> get inputLabelProperty =>
      properties[inputLabelPropertyName] as Property<String>;
  set inputLabelProperty(Property<String> value) =>
      registerProperty(inputLabelPropertyName, value);
  String get inputLabel => inputLabelProperty.value;
  Stream<String> get inputLabelChanged => inputLabelProperty.valueChanged;

  Property<String> get hintProperty =>
      properties[hintPropertyName] as Property<String>;
  set hintProperty(Property<String> value) =>
      registerProperty(hintPropertyName, value);
  String get hint => hintProperty.value;
  Stream<String> get hintChanged => hintProperty.valueChanged;

  Property<String> get helpProperty =>
      properties[helpPropertyName] as Property<String>;
  set helpProperty(Property<String> value) =>
      registerProperty(helpPropertyName, value);
  String get help => helpProperty.value;
  Stream<String> get helpChanged => helpProperty.valueChanged;

  Property<List<Validation>> get validationsProperty =>
      properties[validationsPropertyName] as Property<List<Validation>>;
  set validationsProperty(Property<List<Validation>> value) =>
      registerProperty(validationsPropertyName, value);
  List<Validation> get validations => validationsProperty.value;
  Stream<List<Validation>> get validationsChanged =>
      validationsProperty.valueChanged;

  Property<String> get valueProperty =>
      properties[valuePropertyName] as Property<String>;
  set valueProperty(Property<String> value) =>
      registerProperty(valuePropertyName, value);
  String get value => valueProperty.value;
  Stream<String> get valueChanged => valueProperty.valueChanged;

  @override
  FormElement getInstance() {
    return TextElement();
  }
}
