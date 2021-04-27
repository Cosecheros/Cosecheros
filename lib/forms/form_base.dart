import 'package:cosecheros/forms/events.dart';
import 'package:cosecheros/forms/expressions.dart';
import 'package:cosecheros/forms/form_manager.dart';
import 'package:cosecheros/forms/info/info_parser.dart';
import 'package:cosecheros/forms/info/info_render.dart';
import 'package:cosecheros/forms/label/label.dart';
import 'package:cosecheros/forms/map/map_parser.dart';
import 'package:cosecheros/forms/map/map_render.dart';
import 'package:cosecheros/forms/page/page.dart';
import 'package:cosecheros/forms/page/tab.dart';
import 'package:cosecheros/forms/picture/pic_parser.dart';
import 'package:cosecheros/forms/picture/pic_render.dart';
import 'package:cosecheros/forms/textfield/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as components;

import 'checkbox/checkbox_renderer.dart';
import 'singlechoice/singlechoice_group_parser.dart';
import 'singlechoice/singlechoice_group_renderer.dart';
import 'singlechoice/singlechoice_parser.dart';
import 'singlechoice/singlechoice_renderer.dart';

typedef InitFunction = Future<String> Function();

class BaseForm extends StatefulWidget {
  final InitFunction content;

  BaseForm({this.content});

  @override
  _BaseFormState createState() => _BaseFormState();
}

class _BaseFormState extends State<BaseForm> {
  final CustomFormManager _formManager = CustomFormManager();
  bool isLoading = true;
  Future<String> json;

  @override
  void initState() {
    super.initState();
    json = widget.content();
  }

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
    print(json);
    return FutureBuilder(
      future: json,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _buildError(context);
        }
        if (snapshot.hasData) {
          return _buildData(context, snapshot.data);
        }
        return Container(); // No debería suceder
      },
    );
  }

  Widget _buildError(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 4,
          left: 16,
          child: SafeArea(
            child: TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_rounded),
              label: Text("Volver"),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Ocurrió un problema"),
              IconButton(
                icon: Icon(Icons.refresh_rounded),
                onPressed: () {
                  setState(() {
                    json = widget.content();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildData(BuildContext context, String data) {
    return ParsedFormProvider(
      create: (_) => _formManager,
      content: data,
      parsers: components.getDefaultParserList() +
          [
            SingleChoiceParser(),
            SingleChoiceGroupParser(),
            MapParser(),
            PictureParser(),
            InfoParser(),
          ],
      child: FormRenderer<CustomFormManager>(
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
              SingleChoiceGroupRenderer(),
              MapRenderer(),
              PictureRenderer(),
              InfoRenderer(),
            ],
      ),
      expressionFactories: [ToUpperCaseExpression.get()],
    );
  }
}
