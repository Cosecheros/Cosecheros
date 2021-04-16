import 'package:cosecheros/forms/checkbox/checkbox.dart';
import 'package:cosecheros/forms/events.dart';
import 'package:cosecheros/forms/expressions.dart';
import 'package:cosecheros/forms/label/label.dart';
import 'package:cosecheros/forms/map/map_parser.dart';
import 'package:cosecheros/forms/map/map_render.dart';
import 'package:cosecheros/forms/page/page.dart';
import 'package:cosecheros/forms/page/tab.dart';
import 'package:cosecheros/forms/singlechoice/singlechoice.dart';
import 'package:cosecheros/forms/textfield/text_field.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as components;

class CustomExpressionForm extends StatelessWidget {
  final String _sampleJson = r'''
  {
    "@name": "form",
    "id": "granizo-v1",
    "name": "Granizada",
    "children": [
      {
        "@name": "formGroup",
        "id": "page0",
        "children": [
          {
            "@name": "map",
            "id": "geopoint_map"
          }
        ]
      },
      {
        "@name": "formGroup",
        "id": "formgroup2",
        "name": "2",
        "children": [
          {
            "@name": "checkBox",
            "id": "box1",
            "value": "false",
            "label": "¿toisrntsratael año?"
          },
          {
            "@name": "checkBox",
            "id": "box2",
            "value": "false",
            "label": "¿Larietnra tosratnsraeio tnseroian del año?"
          },
          {
            "@name": "radioButtonGroup",
            "id": "radioGroup1",
            "value": "-1",
            "choices": [
              {
                "@name": "radioButton",
                "label": "Option 1",
                "value": "1"
              },
              {
                "@name": "radioButton",
                "label": "Option 2",
                "value": "2"
              },
              {
                "@name": "radioButton",
                "label": "Option 3",
                "value": "3"
              },
              {
                "@name": "radioButton",
                "label": "Option 4",
                "value": "4"
              },
              {
                "@name": "radioButton",
                "label": "Option 5",
                "value": "5"
              },
              {
                "@name": "radioButton",
                "label": "Option 6",
                "value": "6"
              }
            ]
          }
        ]
      }
    ]
  }
  ''';

  final JsonFormManager _formManager = JsonFormManager();

  void _onEvent(BuildContext context, FormElementEvent event) {
    print(event);

    if (event is ChangeValueEvent) {
      _formManager.changeValue(
          value: event.value,
          elementId: event.elementId,
          propertyName: event.propertyName,
          ignoreLastChange: event.ignoreLastChange);
    }

    if (event is DoneEvent) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      body: ParsedFormProvider(
        create: (_) => _formManager,
        content: _sampleJson,
        parsers: components.getDefaultParserList() + [
          MapParser(),
        ],
        child: FormRenderer<JsonFormManager>(
          dispatcher: (event) {
            _onEvent(context, event);
          },
          renderers: components.getRenderers() +
              [
                TextFieldRenderer(),
                LabelRenderer(),
                TabRenderer(),
                PageRenderer(),
                CheckBoxRenderer(),
                SingleChoiceRenderer(),
                MapRenderer(),
              ],
        ),
        expressionFactories: [ToUpperCaseExpression.get()],
      ),
    );
  }
}
