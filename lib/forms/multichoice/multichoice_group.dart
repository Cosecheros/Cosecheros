import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';

class MultiChoiceGroup extends MultiSelectGroup<MultiSelectChoice> {
  static const String labelPropertyName = 'label';

  String get label => labelProperty.value;
  Stream<String> get labelChanged => labelProperty.valueChanged;
  Property<String> get labelProperty =>
      properties[labelPropertyName] as Property<String>;
  set labelProperty(Property<String> value) =>
      registerProperty(labelPropertyName, value);

  @override
  FormElement getInstance() {
    return MultiSelectChoice();
  }
}
