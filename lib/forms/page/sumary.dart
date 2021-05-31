import 'package:cosecheros/forms/checkbox/checkbox_summary.dart';
import 'package:cosecheros/forms/form_manager.dart';
import 'package:cosecheros/forms/map/map_summary.dart';
import 'package:cosecheros/forms/map/map.dart' as custom;
import 'package:cosecheros/forms/picture/pic.dart';
import 'package:cosecheros/forms/picture/pic_summary.dart';
import 'package:cosecheros/forms/singlechoice/singlechoice_summary.dart';
import 'package:cosecheros/forms/textfield/text_field_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as model;

import 'tab_widget.dart';

typedef BuildSummary<T extends FormElement> = Widget Function(
    BuildContext context, T element);

abstract class SummaryWidget<T extends FormElement> {
  Widget render(BuildContext context, T element);
}

class SumaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var manager = FormProvider.of<CustomFormManager>(context);
    var data = manager.getFormData().reversed;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 56),
        child: ListView(
          padding: EdgeInsets.only(top: 8, bottom: 96.0),
          children: [
            Text(
              "¿Todo listo?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            ...data.map((i) => _getSummary(context, i)).toList()
          ],
        ),
      ),
    );
  }

  final Map<Type, SummaryWidget> summ = {
    Picture: PictureSummary(),
    model.SingleSelectGroup: SingleChoiceSummary(),
    model.CheckBox: CheckBoxSummary(),
    custom.Map: MapSummary(),
    model.TextField: TextFieldSummary(),
  };

  Widget _getSummary(BuildContext context, Map<String, dynamic> input) {
    print("summary: " + input.toString());
    FormElement element = input['formElement'];
    SummaryWidget builder = summ[element.runtimeType];

    if (builder != null) {
      return InkWell(
        child: builder.render(context, element),
        onTap: () {
          try {
            // Busco la página/pantalla (formGroup) del element
            model.FormGroup page =
                element.getFirstParentOfType<model.FormGroup>();
            // Busco el padre de la página (Form)
            model.Form form = page.parent;
            // Busco en que posición está la página dentro de su padre
            // Quitando los hermanos no visibles
            int pos =
                form.children.where((f) => f.isVisible).toList().indexOf(page);
            // Me muevo a esa página
            TabWidget.of(context).moveToPage(pos);
          } catch (e) {
            print("ERROR: No se pudo mover la tab: element: $element");
            print(e);
          }
        },
      );
    }
    print("ERROR: No hay summary implementado: $element");
    return Text("Otras opciones");
  }
}
