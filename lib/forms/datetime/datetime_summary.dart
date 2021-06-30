import 'package:cosecheros/forms/page/sumary.dart';
import 'package:cosecheros/shared/extensions.dart';
import 'package:cosecheros/widgets/info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as model;
import 'package:intl/intl.dart';

class DateTimeSummary extends SummaryWidget<model.Date> {
  @override
  Widget render(BuildContext context, model.Date element) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InfoItem(
        title: element.label,
        childSubtitle: Container(
          margin: EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.history_rounded,
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  DateFormat.yMMMMEEEEd().addPattern("'a las'").add_Hm().format(element.value).capitalize(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
