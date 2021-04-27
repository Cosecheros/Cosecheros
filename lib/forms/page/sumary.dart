import 'package:cosecheros/forms/checkbox/checkbox_summary.dart';
import 'package:cosecheros/forms/form_manager.dart';
import 'package:cosecheros/forms/map/map_summary.dart';
import 'package:cosecheros/forms/map/map.dart' as custom;
import 'package:cosecheros/forms/picture/pic.dart';
import 'package:cosecheros/forms/picture/pic_summary.dart';
import 'package:cosecheros/forms/singlechoice/singlechoice_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';


typedef BuildSummary<T extends FormElement> = Widget Function(
    BuildContext context, T element);

abstract class SummaryWidget<T extends FormElement> {
  Widget render(BuildContext context, T element);
}

class SumaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var manager = FormProvider.of<CustomFormManager>(context);
    var props = manager.getFormProperties();
    var data = manager.getFormData();
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 56),
        child: ListView(
          padding: EdgeInsets.only(top: 8,bottom: 96.0),
          children: [
            Text(
              "¿Todo listo?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            // ...props
            //     .map((i) => Text(
            //           i.property == 'point'
            //               ? '${i.id} = ${i.property}: ${i.value}'
            //               : '${i.id} = ${i.property}: ${i.value}',
            //           style: Theme.of(context).textTheme.bodyText1.apply(
            //               color: i.value == "false" || i.value == ""
            //                   ? Colors.red
            //                   : Colors.green),
            //         ))
            //     .toList(),
            SizedBox(height: 16),
            ...data.map((i) => _getSummary(context, i)).toList()
          ],
        ),
      ),
    );
  }

  final Map<Type, SummaryWidget> summ = {
    Picture: PictureSummary(),
    SingleSelectGroup: SingleChoiceSummary(),
    CheckBox: CheckBoxSummary(),
    custom.Map: MapSummary(),
  };

  Widget _getSummary(BuildContext context, Map<String, dynamic> input) {
    print(input);
    var element = input['formElement'];
    var builder = summ[element.runtimeType];

    if (builder != null) {
      return builder.render(context, element);
    }
    print("nop");
    return Text("otro");
  }
}
