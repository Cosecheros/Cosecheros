import 'package:cosecheros/forms/text/text.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter/services.dart';

class TextParser<TTextField extends TextElement>
    extends FormElementParser<TTextField> {
  @override
  String get name => 'textField';

  @override
  FormElement getInstance() => TextElement();

  @override
  void fillProperties(
    TTextField textField,
    ParserNode parserNode,
    Element parent,
    ElementParserFunction parser,
  ) {
    super.fillProperties(textField, parserNode, parent, parser);
    textField
      ..inputTypeProperty = parserNode.getProperty(
        'inputType',
        (s) => getTextInputType(s),
        () => TextInputType.text,
        isImmutable: true,
      )
      ..labelProperty = parserNode.getStringProperty(
        'label',
        defaultValue: ParserNode.defaultString,
        isImmutable: true,
      )
      ..inputLabelProperty = parserNode.getStringProperty(
        'inputLabel',
        defaultValue: ParserNode.defaultString,
        isImmutable: true,
      )
      ..hintProperty = parserNode.getStringProperty(
        'hint',
        defaultValue: ParserNode.defaultString,
        isImmutable: true,
      )
      ..helpProperty = parserNode.getStringProperty(
        'help',
        defaultValue: ParserNode.defaultString,
        isImmutable: true,
      )
      ..validationsProperty = parserNode.getChildrenProperty<Validation>(
          parent: textField,
          parser: parser,
          childrenPropertyName: 'validations',
          isContentProperty: false)
      ..valueProperty = parserNode.getStringProperty(
        'value',
        defaultValue: ParserNode.defaultString,
        isImmutable: false,
      );
  }

  TextInputType getTextInputType(String textInputType) {
    TextInputType result;

    switch (textInputType) {
      case 'datetime':
        result = TextInputType.datetime;
        break;
      case 'emailAddress':
        result = TextInputType.emailAddress;
        break;
      case 'multiline':
        result = TextInputType.multiline;
        break;
      case 'number':
        result = TextInputType.number;
        break;
      case 'money':
        result = TextInputType.numberWithOptions(signed: false, decimal: true);
        break;
      case 'phone':
        result = TextInputType.phone;
        break;
      case 'text':
        result = TextInputType.text;
        break;
      case 'url':
        result = TextInputType.url;
        break;
      default:
        result = TextInputType.text;
        break;
    }
    return result;
  }
}
