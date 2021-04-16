import 'package:dynamic_forms/dynamic_forms.dart';
import 'map.dart';

class MapParser extends FormElementParser<Map> {
  @override
  String get name => 'map';

  @override
  FormElement getInstance() => Map();

  @override
  void fillProperties(
    Map map,
    ParserNode parserNode,
    Element parent,
    ElementParserFunction parser,
  ) {
    super.fillProperties(map, parserNode, parent, parser);

    map.pointProperty = parserNode.getProperty(
      'point',
      (String s) => null, // TODO
      () => GeoPos(-31.416998, -64.183657),
      isImmutable: false,
    );
  }
}
