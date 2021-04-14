import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as model;

class CheckBoxRenderer extends FormElementRenderer<model.CheckBox> {
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

  void changeValue(dispatcher, element) {
    dispatcher(
      ChangeValueEvent(
        value: !element.value,
        elementId: element.id,
      ),
    );
  }

  @override
  Widget render(
      model.CheckBox element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    return StreamBuilder<bool>(
        initialData: element.value,
        stream: element.valueChanged,
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            decoration: getDecorationBox(context, element.value),
            clipBehavior: Clip.antiAlias,
            height: 72,
            child: InkWell(
              onTap: () => changeValue(dispatcher, element),
              borderRadius: BorderRadius.circular(10),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    onChanged: (_) {
                      changeValue(dispatcher, element);
                    },
                    value: snapshot.data,
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        element.label,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: snapshot.data
                                ? Theme.of(context).colorScheme.primaryVariant
                                : Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
