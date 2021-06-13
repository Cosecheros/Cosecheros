import 'package:cosecheros/forms/page/sumary.dart';
import 'package:cosecheros/forms/singlechoice/singlechoice_group.dart';
import 'package:cosecheros/widgets/info_item.dart';
import 'package:cosecheros/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SingleChoiceSummary extends SummaryWidget<SingleChoiceGroup> {
  @override
  Widget render(BuildContext context, SingleChoiceGroup element) {
    var selected = element.choices.singleWhere(
      (choice) => choice.value == element.value,
      orElse: () => null,
    );
    if (selected == null) return SizedBox();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InfoItem(
        title: element.label,
        subtitle: selected.label,
      ),
    );
  }
}
