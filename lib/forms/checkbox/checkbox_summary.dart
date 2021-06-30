import 'package:cosecheros/forms/page/sumary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as model;

@Deprecated("usar multichoice")
class CheckBoxSummary extends SummaryWidget<model.CheckBox> {
  @override
  Widget render(BuildContext context, model.CheckBox element) {
    if (!element.value) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              element.label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
