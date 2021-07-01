import 'package:cosecheros/forms/checkbox/checkbox_summary.dart';
import 'package:cosecheros/forms/datetime/datetime_summary.dart';
import 'package:cosecheros/forms/form_manager.dart';
import 'package:cosecheros/forms/info/info.dart';
import 'package:cosecheros/forms/map/map_summary.dart';
import 'package:cosecheros/forms/map/map.dart' as custom;
import 'package:cosecheros/forms/multichoice/multichoice_group.dart';
import 'package:cosecheros/forms/multichoice/multichoice_summary.dart';
import 'package:cosecheros/forms/picture/pic.dart';
import 'package:cosecheros/forms/picture/pic_summary.dart';
import 'package:cosecheros/forms/singlechoice/singlechoice_group.dart';
import 'package:cosecheros/forms/singlechoice/singlechoice_summary.dart';
import 'package:cosecheros/forms/textfield/text_field_summary.dart';
import 'package:cosecheros/widgets/label_widget.dart';
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

class NopeSummary extends SummaryWidget {
  @override
  Widget render(BuildContext context, FormElement element) {
    return Container();
  }
}

class SumaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var manager = FormProvider.of<CustomFormManager>(context);
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 56),
        child: ListView(
          padding: EdgeInsets.only(top: 8, bottom: 96.0),
          children: [
            LabelWidget("¿Todo listo?"),
            SizedBox(height: 16),
            ...manager
                .getVisibleFormElementIterator(manager.form)
                .where((element) => element.isVisible)
                .map((e) => _toSummary(context, e))
                .where((element) => element != null)
                .toList()
                .reversed
          ],
        ),
      ),
    );
  }

  final Map<Type, SummaryWidget> summ = {
    Picture: PictureSummary(),
    SingleChoiceGroup: SingleChoiceSummary(),
    MultiChoiceGroup: MultiChoiceSummary(),
    model.CheckBox: CheckBoxSummary(),
    custom.Map: MapSummary(),
    model.TextField: TextFieldSummary(),
    model.Date: DateTimeSummary(),

    model.SingleSelectChoice: NopeSummary(),
    model.MultiSelectChoice: NopeSummary(),
    model.Label: NopeSummary(),
    model.FormGroup: NopeSummary(),
    model.Form: NopeSummary(),
    Info: NopeSummary(),
  };

  Widget _toSummary(BuildContext context, FormElement element) {
    print("_toSummary: " + element.toString());
    SummaryWidget builder = summ[element.runtimeType];

    if (builder is NopeSummary) {
      return null;
    }

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
    return Text("Otra opción: $element");
  }
}
