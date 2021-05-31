import 'package:cosecheros/forms/page/sumary.dart';
import 'package:cosecheros/widgets/info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as model;

class TextFieldSummary extends SummaryWidget<model.TextField> {
  Widget render(BuildContext context, model.TextField element) {
    if (element.value.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InfoItem(
        title: element.label,
        subtitle: element.value,
      ),
    );
  }

  String idToTitle(id) {
    return id.split("_")[0].capitalize() + ".";
  }
}
