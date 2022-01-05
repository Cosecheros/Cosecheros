import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';

import 'singlechoice_group.dart';

class SingleChoiceGroupParser
    extends SingleSelectGroupParser<SingleChoiceGroup, SingleSelectChoice> {
  @override
  String get name => 'singleChoice';

  @override
  void fillProperties(
    SingleChoiceGroup singleChoiceGroup,
    ParserNode parserNode,
    Element parent,
    ElementParserFunction parser,
  ) {
    super.fillProperties(singleChoiceGroup, parserNode, parent, parser);
    singleChoiceGroup.labelProperty =
        parserNode.getStringProperty(SingleChoiceGroup.labelPropertyName);
  }

  @override
  FormElement getInstance() => SingleChoiceGroup();
}
