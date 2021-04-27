import 'package:cosecheros/forms/form_base.dart';
import 'package:flutter/material.dart';

class CustomExpressionForm extends StatelessWidget {
  final String _sampleJson = r'''
  {
    "@name": "form",
    "id": "granizo_v1",
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
        "id": "page1",
        "children": [
          {
            "@name": "label",
            "value": "Sácale una foto a la granizada."
          },
          {
            "@name": "pic",
            "id": "granizo_pic"
          },
          {
            "@name": "label",
            "value": "Recuerda:"
          },
          {
            "@name": "info",
            "title": "Busca un lugar abierto lejos de paredes.",
            "subtitle": "Queremos que el granizo esté sano y distribuido uniformemente.",
            "img": "https://mincyt-granizo.web.app/info/photographer.png"
          }
        ]
      },
      {
        "@name": "formGroup",
        "id": "page2",
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
            "@name": "choices",
            "id": "grupito",
            "choices": [
              {
                "@name": "choice",
                "label": "Option 1",
                "value": "1"
              },
              {
                "@name": "choice",
                "label": "Option 2",
                "value": "2"
              },
              {
                "@name": "choice",
                "label": "Option 3",
                "value": "3"
              },
              {
                "@name": "choice",
                "label": "Option 4",
                "value": "4"
              },
              {
                "@name": "choice",
                "label": "Option 5",
                "value": "5"
              },
              {
                "@name": "choice",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      body: BaseForm(
        content: () => Future.value(_sampleJson),
      ),
    );
  }
}
