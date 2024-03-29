import 'package:cosecheros/forms/page/tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as model;
import 'package:rxdart/rxdart.dart';

class SingleChoiceRenderer
    extends FormElementRenderer<model.SingleSelectChoice> {
  BoxDecoration getDecorationBox(context, value) {
    return value
        ? BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.primary,
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
      model.SingleSelectChoice element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    var parent = element.parent as model.SingleSelectGroup;

    return LazyStreamBuilder<String>(
      initialData: parent.value,
      streamFactory: () =>
          MergeStream([parent.valueChanged, element.propertyChanged]),
      builder: (context, _) {
        return Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 4),
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
              TabWidget.of(context).movePage(1);
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  element.label.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: element.value == parent.value
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: element.value == parent.value
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onBackground),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
