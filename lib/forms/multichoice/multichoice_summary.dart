import 'package:cosecheros/forms/multichoice/multichoice_group.dart';
import 'package:cosecheros/forms/page/sumary.dart';
import 'package:cosecheros/widgets/info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';

class MultiChoiceSummary extends SummaryWidget<MultiChoiceGroup> {
  @override
  Widget render(BuildContext context, MultiChoiceGroup element) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InfoItem(
        title: element.label,
        childSubtitle: Column(
          children: [
            ...element.choices
                .where((element) => element.isSelected)
                .map((e) => getItem(context, e))
          ],
        ),
      ),
    );
  }

  Widget getItem(BuildContext context, MultiSelectChoice element) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
