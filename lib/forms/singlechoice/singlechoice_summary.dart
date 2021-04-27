import 'package:cosecheros/forms/page/sumary.dart';
import 'package:cosecheros/shared/info_item.dart';
import 'package:cosecheros/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as model;

class SingleChoiceSummary extends SummaryWidget<model.SingleSelectGroup> {
  @override
  Widget render(BuildContext context, model.SingleSelectGroup element) {
    var selected = element.choices.singleWhere(
      (choice) => choice.value == element.value,
      orElse: () => null,
    );
    if (selected == null) return SizedBox();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InfoItem(
        title: idToTitle(element.id),
        subtitle: selected.label,
      ),
    );
  }

  String idToTitle(String id) {
    return id.replaceAll('_', ' ').capitalize() + ".";
  }
}
