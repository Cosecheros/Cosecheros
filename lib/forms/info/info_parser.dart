import 'package:dynamic_forms/dynamic_forms.dart';

import 'info.dart';

class InfoParser extends FormElementParser<Info> {
  @override
  String get name => 'info';

  @override
  void fillProperties(
    Info info,
    ParserNode parserNode,
    Element parent,
    ElementParserFunction parser,
  ) {
    super.fillProperties(info, parserNode, parent, parser);
    info.titleProperty = parserNode.getNullableStringProperty('title');
    info.subtitleProperty = parserNode.getNullableStringProperty('subtitle');
    info.imgProperty = parserNode.getNullableStringProperty('img');
  }

  @override
  FormElement getInstance() => Info();
}
