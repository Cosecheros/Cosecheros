import 'package:cosecheros/forms/datetime/datetime_renderer.dart';
import 'package:cosecheros/forms/multichoice/multichoice_group_parser.dart';
import 'package:cosecheros/forms/multichoice/multichoice_group_renderer.dart';
import 'package:cosecheros/forms/multichoice/multichoice_parser.dart';
import 'package:cosecheros/forms/multichoice/multichoice_renderer.dart';
import 'package:cosecheros/forms/submit_firestore.dart';
import 'package:cosecheros/forms/text/text_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as components;

import 'checkbox/checkbox_renderer.dart';
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
import 'singlechoice/singlechoice_group_parser.dart';
import 'singlechoice/singlechoice_group_renderer.dart';
import 'singlechoice/singlechoice_parser.dart';
import 'singlechoice/singlechoice_renderer.dart';
import 'text/text_renderer.dart';

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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: json,
          builder: _buildForm,
        ),
        if (upload != null)
          Container(
            decoration: BoxDecoration(color: Colors.black45),
            child: Center(
              child: StreamBuilder(
                stream: upload,
                builder: _buildUpload,
              ),
            ),
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    json = widget.content();
  }

  Widget _buildForm(context, snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return _buildFormError(context, onRetry: () {
        setState(() {
          json = widget.content();
        });
      }, onBack: () {
        Navigator.pop(context);
      });
    }
    if (snapshot.hasData) {
      return _buildFormData(context, snapshot.data);
    }
    return Container(); // No debería suceder
  }

  // TODO: Retry on error

  Widget _buildFormData(BuildContext context, String data) {
    return ParsedFormProvider(
      create: (_) => _formManager,
      content: data,
      parsers: components.getDefaultParserList() +
          [
            SingleChoiceParser(),
            SingleChoiceGroupParser(),
            MultiChoiceParser(),
            MultiChoiceGroupParser(),
            MapParser(),
            PictureParser(),
            InfoParser(),
            TextParser(),
          ],
      child: FormRenderer<CustomFormManager>(
        dispatcher: (event) {
          _onEvent(context, event);
        },
        renderers: components.getRenderers() +
            [
              TextRenderer(),
              LabelRenderer(),
              TabRenderer(),
              PageRenderer(),
              CheckBoxRenderer(),
              SingleChoiceRenderer(),
              SingleChoiceGroupRenderer(),
              MultiChoiceRenderer(),
              MultiChoiceGroupRenderer(),
              MapRenderer(),
              PictureRenderer(),
              InfoRenderer(),
              DateTimeRenderer(),
            ],
      ),
      expressionFactories: [ToUpperCaseExpression.get()],
    );
  }

  Widget _buildFormError(BuildContext context,
      {VoidCallback onRetry, VoidCallback onBack}) {
    return Stack(
      children: [
        Positioned(
          top: 4,
          left: 16,
          child: SafeArea(
            child: TextButton.icon(
              onPressed: onBack,
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
                onPressed: onRetry,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpload(
      BuildContext context, AsyncSnapshot<SubmitProgress> event) {
    print("uploading: $event");
    if (event.connectionState == ConnectionState.waiting) {
      return _circularProgress(null);
    }

    if (event.hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Ocurrió un problema",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.white),
            ),
            SizedBox(height: 16),
            _retryButton(_onSubmit),
            TextButton(
              onPressed: () {
                setState(() {
                  upload = null;
                });
              },
              child: Text(
                "Volver",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
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
  }

  Widget _circularProgress(double value) {
    return SizedBox(
      height: 64.0,
      width: 64.0,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.secondary,
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
      fillColor: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.all(16.0),
    );
  }

  void _onEvent(BuildContext context, FormElementEvent event) {
    print("_onEvent: $event");

    if (event is ChangeValueEvent) {
      print("_onEvent: elementId: ${event.elementId}, value: ${event.value}");
      _formManager.changeValue(
          value: event.value,
          elementId: event.elementId,
          propertyName: event.propertyName,
          ignoreLastChange: event.ignoreLastChange);
    }

    if (event is DoneEvent) {
      _onSubmit();
    }
  }

  void _onSubmit() {
    setState(() {
      upload = _submiter.submit(_formManager);
    });
  }

  Widget _retryButton(VoidCallback onRetry) {
    return RawMaterialButton(
      onPressed: onRetry,
      child: Icon(
        Icons.refresh_rounded,
        color: Colors.white,
        size: 32.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.all(16.0),
    );
  }
}
