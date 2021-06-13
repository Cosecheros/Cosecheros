import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';
import 'package:dynamic_forms/dynamic_forms.dart';

class MultiChoiceParser<TMultiSelectChoice extends MultiSelectChoice>
    extends MultiSelectChoiceParser<TMultiSelectChoice> {
  @override
  String get name => 'multi';

  @override
  void fillProperties(
    MultiSelectChoice multiSelectChoice,
    ParserNode parserNode,
    Element parent,
    ElementParserFunction parser,
  ) {
    super.fillProperties(multiSelectChoice, parserNode, parent, parser);
    multiSelectChoice.id = "${parent.id}:${multiSelectChoice.id}";
  }
}
