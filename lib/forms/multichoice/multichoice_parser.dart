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
    final id = parserNode.getPlainString('id') ??
        multiSelectChoice.label
            .trim()
            .replaceAll(RegExp(r' '), '_')
            .toLowerCase();
    multiSelectChoice.id = "${parent.id}_$id";
  }
}
