import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';
import 'package:dynamic_forms/dynamic_forms.dart';

class SingleChoiceGroup extends SingleSelectGroup<SingleSelectChoice> {
  static const String labelPropertyName = 'label';

  Property<String> get labelProperty => properties[labelPropertyName] as Property<String>;
  set labelProperty(Property<String> value) =>
      registerProperty(labelPropertyName, value);
  String get label =>
      labelProperty.value;
  Stream<String> get labelChanged => labelProperty.valueChanged;

  @override
  FormElement getInstance() {
    return SingleSelectChoice();
  }
}