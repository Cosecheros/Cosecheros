import 'package:cosecheros/widgets/label_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';
import 'package:rxdart/rxdart.dart';

import 'singlechoice_group.dart';

class SingleChoiceGroupRenderer extends FormElementRenderer<SingleChoiceGroup> {
  @override
  Widget render(
      SingleChoiceGroup element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    return StreamBuilder<List<SingleSelectChoice>>(
      initialData: element.choices,
      stream: element.choicesChanged,
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: MergeStream(
            snapshot.data.map((child) => child.isVisibleChanged),
          ),
          builder: (context, _) => Column(
            children: [
              LabelWidget(element.label),
              SizedBox(height: 8),
              ...element.choices
                  .where((c) => c.isVisible)
                  .map((choice) => renderer(choice, context))
                  .toList(),
            ],
          ),
        );
      },
    );
  }
}
