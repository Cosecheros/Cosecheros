import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';
import 'package:dynamic_forms/dynamic_forms.dart';

class SingleChoiceGroupParser
    extends SingleSelectGroupParser<SingleSelectGroup, SingleSelectChoice> {
  @override
  String get name => 'choices';

  @override
  FormElement getInstance() => SingleSelectGroup();
}
