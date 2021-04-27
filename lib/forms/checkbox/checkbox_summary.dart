import 'package:cosecheros/forms/page/sumary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as model;

class CheckBoxSummary extends SummaryWidget<model.CheckBox> {
  @override
  Widget render(BuildContext context, model.CheckBox element) {
    if (!element.value) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal:16, vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 8),
          Text(element.label),
        ],
      ),
    );
  }
}
