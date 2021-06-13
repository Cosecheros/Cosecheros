import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';
import 'package:dynamic_forms/dynamic_forms.dart';

class SingleChoiceParser extends SingleSelectChoiceParser<SingleSelectChoice> {
  @override
  String get name => 'single';

  @override
  void fillProperties(
    SingleSelectChoice singleSelectChoice,
    ParserNode parserNode,
    Element parent,
    ElementParserFunction parser,
  ) {
    super.fillProperties(singleSelectChoice, parserNode, parent, parser);
    singleSelectChoice
      ..labelProperty = parserNode.getStringProperty(
        'label',
        defaultValue: ParserNode.defaultString,
        isImmutable: true,
      )
      ..valueProperty = parserNode.getStringProperty(
        'value',
        defaultValue: () => singleSelectChoice.label
            .trim()
            .replaceAll(RegExp(r' '), '_')
            .toLowerCase(),
        isImmutable: true,
      );
  }
}
