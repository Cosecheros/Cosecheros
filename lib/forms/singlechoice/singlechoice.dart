import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as model;

class SingleChoiceRenderer extends FormElementRenderer<model.RadioButton> {
  BoxDecoration getDecorationBox(context, value) {
    return value
        ? BoxDecoration(
            color: Theme.of(context).colorScheme.primaryVariant.withAlpha(12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
          )
        : BoxDecoration(
            color: Colors.black.withOpacity(.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 2,
              color: Colors.transparent,
            ),
          );
  }

  @override
  Widget render(
      model.RadioButton element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    var parent = element.parent as model.RadioButtonGroup;

    return LazyStreamBuilder<String>(
      initialData: parent.value,
      streamFactory: () =>
          MergeStream([parent.valueChanged, element.propertyChanged]),
      builder: (context, _) {
        return Container(
          height: 72,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          decoration: getDecorationBox(context, element.value == parent.value),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              dispatcher(
                ChangeValueEvent(
                    value: element.value,
                    elementId: parent.id,
                    propertyName: model.SingleSelectGroup.valuePropertyName),
              );
            },
            child: Center(
              child: Text(
                element.label.toUpperCase(),
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: element.value == parent.value
                        ? Theme.of(context).colorScheme.primaryVariant
                        : Theme.of(context).colorScheme.onBackground),
              ),
            ),
          ),
        );
      },
    );
  }
}
