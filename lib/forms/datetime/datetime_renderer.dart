import 'package:cosecheros/widgets/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cosecheros/shared/extensions.dart';

import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as model;

class DateTimeRenderer extends FormElementRenderer<model.Date> {
  @override
  Widget render(
      model.Date element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    void onPicked(DateTime dateTime) {
      dispatcher(
        ChangeValueEvent(
          value: dateTime,
          elementId: element.id,
          // propertyName: model.Date.valuePropertyName,
        ),
      );
    }

    return StreamBuilder(
      stream: element.valueChanged,
      builder: (BuildContext context, _) {
        if (element.value == null) {
          onPicked(DateTime.now());
        }
        final DateTime selected = element.value;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              LabelWidget(element.label),
              SizedBox(height: 16),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    formatDate(selected),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now(),
                    initialDate: selected,
                    locale: Locale('es'),
                  );

                  if (date == null) {
                    return;
                  }

                  onPicked(DateTime(date.year, date.month, date.day,
                      selected.hour, selected.minute));
                },
              ),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    DateFormat("hh:mm a").format(selected),
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .color
                            .withOpacity(0.8)),
                  ),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());

                  TimeOfDay time = await showTimePicker(
                    initialTime: TimeOfDay.fromDateTime(selected),
                    context: context,
                    // builder: (BuildContext context, Widget child) {
                    //   return MediaQuery(
                    //     data: MediaQuery.of(context)
                    //         .copyWith(alwaysUse24HourFormat: false),
                    //     child: child,
                    //   );
                    // },
                  );

                  if (time == null) {
                    return;
                  }
                  print(time);
                  onPicked(
                    DateTime(
                      selected.year,
                      selected.month,
                      selected.day,
                      time.hour,
                      time.minute,
                      0,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String formatDate(DateTime date) {
    if (DateTime.now().isSameDate(date)) {
      return "Hoy";
    }
    if (DateTime.now().subtract(Duration(days: 1)).isSameDate(date)) {
      return "Ayer";
    }
    if (DateTime.now().subtract(Duration(days: 2)).isSameDate(date)) {
      return "Antes de ayer";
    }
    return DateFormat("'El' EEEE d 'de' MMMM 'del' yyyy").format(date);
  }
}
