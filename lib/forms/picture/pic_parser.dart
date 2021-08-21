import 'package:dynamic_forms/dynamic_forms.dart';
import 'pic.dart';

class PictureParser extends FormElementParser<Picture> {
  @override
  String get name => 'pic';

  @override
  FormElement getInstance() => Picture();

  @override
  void fillProperties(
    Picture pic,
    ParserNode parserNode,
    Element parent,
    ElementParserFunction parser,
  ) {
    super.fillProperties(pic, parserNode, parent, parser);
    pic.pathProperty = parserNode.getNullableStringProperty(
      'path',
      isImmutable: false,
    );
    pic.labelProperty = parserNode.getStringProperty(
      'label',
      defaultValue: () => 'Foto de la cosecha',
      isImmutable: true,
    );
  }
}
