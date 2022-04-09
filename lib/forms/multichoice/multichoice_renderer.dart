import 'package:cosecheros/widgets/multichoice_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as model;

class MultiChoiceRenderer extends FormElementRenderer<model.MultiSelectChoice> {
  @override
  Widget render(
      model.MultiSelectChoice element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    return StreamBuilder<bool>(
        initialData: element.isSelected,
        stream: element.isSelectedChanged,
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: MultiChoiceWidget(
              label: element.label,
              onChanged: (value) => dispatcher(
                ChangeValueEvent(
                  value: value,
                  elementId: element.id,
                  propertyName: model.MultiSelectChoice.isSelectedPropertyName,
                ),
              ),
              isSelected: snapshot.data,
            ),
          );
        });
  }
}
