import 'package:expression_language/expression_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as model;
import 'package:dynamic_forms/dynamic_forms.dart';

class PageRenderer extends FormElementRenderer<model.FormGroup> {
  @override
  Widget render(
      model.FormGroup element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    return StreamBuilder<List<ExpressionProviderElement>>(
      initialData: element.children,
      stream: element.childrenChanged,
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: MergeStream(
            snapshot.data
                .whereType<FormElement>()
                .map((child) => child.isVisibleChanged),
          ),
          builder: (context, _) {
            // Keyboard padding
            double bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return SafeArea(
              child: Container(
                margin: EdgeInsets.only(
                  top: 56,
                  bottom: bottomInset,
                ),
                child: ListView(
                  padding: EdgeInsets.only(
                    top: 8,
                    // Padding para el botón "siguiente" (96 de alto)
                    // excepto cuando está abierto el teclado,
                    // ya que en ese caso el botón no se ve.
                    bottom: bottomInset == 0 ? 96 : 8,
                  ),
                  children: [
                    ...snapshot.data
                        .whereType<FormElement>()
                        .where((f) => f.isVisible)
                        .map((child) => renderer(child, context)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
