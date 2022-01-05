import 'package:cosecheros/widgets/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:rxdart/rxdart.dart';

import 'multichoice_group.dart';

class MultiChoiceGroupRenderer extends FormElementRenderer<MultiChoiceGroup> {
  @override
  Widget render(
      MultiChoiceGroup element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    return LazyStreamBuilder(
      streamFactory: () => MergeStream(
        [
          ...element.choices.map((o) => o.isVisibleChanged),
          element.propertyChanged
        ],
      ),
      builder: (context, _) {
        return Column(children: [
          LabelWidget(element.label),
          SizedBox(height: 8),
          ...element.choices
              .where((c) => c.isVisible)
              .map((choice) => renderer(choice, context))
              .toList(),
        ]);
      },
    );
  }
}
