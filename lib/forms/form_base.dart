import 'package:cosecheros/forms/submit_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as components;

import 'events.dart';
import 'expressions.dart';
import 'form_manager.dart';
import 'info/info_parser.dart';
import 'info/info_render.dart';
import 'label/label.dart';
import 'map/map_parser.dart';
import 'map/map_render.dart';
import 'page/page.dart';
import 'page/tab.dart';
import 'picture/pic_parser.dart';
import 'picture/pic_render.dart';
import 'textfield/text_field_renderer.dart';
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
  final SubmitFirestore _submiter = SubmitFirestore();
  bool isLoading = true;
  Future<String> json;
  Stream<SubmitProgress> upload;

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
      setState(() {
        upload = _submiter.submit(
          _formManager.form.id,
          _formManager.getElementsData(),
        );
      });
    }
  }

  // TODO: Retry on error

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
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
        ),
        if (upload != null)
          WillPopScope(
            onWillPop: () async => false, // Fixme: Prevenir retroceder el form
            child: Container(
              decoration: BoxDecoration(color: Colors.black45),
              child: Center(
                child: StreamBuilder(
                    stream: upload,
                    builder: (BuildContext context,
                        AsyncSnapshot<SubmitProgress> event) {
                      print(event);
                      if (event.connectionState == ConnectionState.waiting) {
                        return _circularProgress(null);
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            event.data?.task ?? "Error",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          if (event.connectionState == ConnectionState.done)
                            _doneButton()
                          else
                            _circularProgress(event.data.progress)
                        ],
                      );
                    }),
              ),
            ),
          ),
      ],
    );
  }

  Widget _circularProgress(double value) {
    return SizedBox(
      height: 64.0,
      width: 64.0,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primaryVariant,
        ),
        value: value,
      ),
    );
  }

  Widget _doneButton() {
    return RawMaterialButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Icon(
        Icons.done,
        color: Colors.white,
        size: 32.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Theme.of(context).colorScheme.primaryVariant,
      padding: const EdgeInsets.all(16.0),
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
