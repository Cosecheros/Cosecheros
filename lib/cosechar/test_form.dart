import 'package:cosecheros/forms/checkbox/checkbox.dart';
import 'package:cosecheros/forms/events.dart';
import 'package:cosecheros/forms/expressions.dart';
import 'package:cosecheros/forms/label/label.dart';
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
        "id": "page1",
        "children": [
          {
            "@name": "label",
            "value": "¿Cual de las siguientes opciones se asemeja a tu situación?"
          },
          {
            "@name": "checkBox",
            "id": "situacion_actual_año",
            "label": "¿La situación actual es la que se espera para la epoca del año?"
          },

          {
            "@name": "textField",
            "id": "situacion_obs2",
            "label": "Observaciones",
            "inputType": "multiline"
          },
          {
            "@name": "checkBox",
            "id": "animales_crecen_restricciones",
            "label": "¿Los animales crecen cercano a su potencial sin sustanciales restricciones?"
          },
          {
            "@name": "checkBox",
            "id": "forrajes_merma_crecimiento",
            "label": "¿Los forrajes presentan mermas en su crecimiento?"
          },
          {
            "@name": "checkBox",
            "id": "perdida_peso_animal",
            "label": "Perdida considerable de peso animal"
          },
          {
            "@name": "checkBox",
            "id": "realiza_suplementa_alimenticia",
            "label": "Se realiza suplementación alimenticia estratégica"
          },
          {
            "@name": "checkBox",
            "id": "lotes_forrajeras_amarillo",
            "label": "Existen lotes de forrajeras con amarillamientos generalizados"
          },
          {
            "@name": "checkBox",
            "id": "cultivos_sufren_defoliación",
            "label": "Los cultivos/forrajeras sufren defoliación (pierden hojas secas)"
          },
          {
            "@name": "checkBox",
            "id": "lotes_enfermedades_generalizdas",
            "label": "Existen lotes (rodeos animales) con enfermedades generalizadas"
          },
          {
            "@name": "checkBox",
            "id": "presencia_plagas_generalizadas",
            "label": "Presencia de plagas generalizadas"
          },
          {
            "@name": "checkBox",
            "id": "merma_agua_calidad",
            "label": "Merma en abastecimiento de agua de calidad para bebida/riego"
          },
          {
            "@name": "checkBox",
            "id": "perdida_fuente_agua",
            "label": "Perdidas de fuentes de agua para bebida/riego"
          },
          {
            "@name": "checkBox",
            "id": "disminución_considerable_pariciones",
            "label": "Disminución considerable de preñeces/pariciones"
          },
          {
            "@name": "checkBox",
            "id": "venta_de_vientres",
            "label": "Venta de vientres"
          },
          {
            "@name": "checkBox",
            "id": "remates_generalizados_rodeos",
            "label": "Remates generalizados de rodeos"
          },
          {
            "@name": "checkBox",
            "id": "muerte_de_animales",
            "label": "Muerte de animales"
          },
          {
            "@name": "checkBox",
            "id": "pedidas_consecuencia_evidente",
            "label": "Las perdidas económicas son consecuencia evidente"
          },
          {
            "@name": "label",
            "value": "¿Alguna cosa más?"
          },
          {
            "@name": "textField",
            "id": "situacion_obs",
            "label": "Observaciones",
            "inputType": "multiline"
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
        parsers: components.getDefaultParserList(),
        child: FormRenderer<JsonFormManager>(
          dispatcher: (event) {
            _onEvent(context, event);
          },
          renderers: components.getReactiveRenderers() +
              [
                TextFieldRenderer(),
                LabelRenderer(),
                TabRenderer(),
                PageRenderer(),
                CheckBoxRenderer(),
                SingleChoiceRenderer(),
              ],
        ),
        expressionFactories: [ToUpperCaseExpression.get()],
      ),
    );
  }
}
