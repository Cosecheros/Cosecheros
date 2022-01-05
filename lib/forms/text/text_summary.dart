import 'package:cosecheros/forms/page/sumary.dart';
import 'package:cosecheros/forms/text/text.dart';
import 'package:cosecheros/widgets/info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextSummary extends SummaryWidget<TextElement> {
  String idToTitle(id) {
    return id.split("_")[0].capitalize() + ".";
  }

  Widget render(BuildContext context, TextElement element) {
    if (element.value.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InfoItem(
        title: "${element.label} (${element.inputLabel.toLowerCase()})",
        subtitle: element.value,
      ),
    );
  }
}
