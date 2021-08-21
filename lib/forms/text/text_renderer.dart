import 'package:cosecheros/forms/text/text.dart';
import 'package:cosecheros/forms/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';

class TextRenderer extends FormElementRenderer<TextElement> {
  @override
  Widget render(
      TextElement element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    return StreamBuilder(
      stream: element.propertyChanged,
      builder: (context, _) {
        var errorText = element.validations
            .firstWhere((v) => !v.isValid, orElse: () => null)
            ?.message;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: TextWidget(
            element: element,
            errorText: errorText,
            dispatcher: dispatcher,
          ),
        );
      },
    );
  }
}
