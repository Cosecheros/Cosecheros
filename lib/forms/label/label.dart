import 'package:cosecheros/widgets/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as model;

class LabelRenderer extends FormElementRenderer<model.Label> {
  @override
  Widget render(
      model.Label element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    return Center(
      child: StreamBuilder<String>(
          initialData: element.value,
          stream: element.valueChanged,
          builder: (context, snapshot) {
            return LabelWidget(snapshot.data);
          }),
    );
  }
}
