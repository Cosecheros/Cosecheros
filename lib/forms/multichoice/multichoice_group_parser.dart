import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';

import 'multichoice_group.dart';

class MultiChoiceGroupParser
    extends MultiSelectGroupParser<MultiChoiceGroup, MultiSelectChoice> {
  @override
  String get name => 'multiChoice';

  @override
  void fillProperties(
    MultiChoiceGroup multiChoiceGroup,
    ParserNode parserNode,
    Element parent,
    ElementParserFunction parser,
  ) {
    super.fillProperties(multiChoiceGroup, parserNode, parent, parser);
    multiChoiceGroup.labelProperty =
        parserNode.getStringProperty(MultiChoiceGroup.labelPropertyName);
  }

  @override
  FormElement getInstance() => MultiChoiceGroup();
}
