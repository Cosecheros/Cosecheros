import 'dart:io';

import 'package:cosecheros/forms/page/sumary.dart';
import 'package:cosecheros/shared/extensions.dart';
import 'package:cosecheros/widgets/info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'pic.dart';

class PictureSummary extends SummaryWidget<Picture> {
  Widget render(BuildContext context, Picture element) {
    if (element.path == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: InfoItem(
          title: idToTitle(element.id),
          subtitle: "Sin foto.",
          childImage: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.no_photography_rounded,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
        ),
      );
    }
    File f = File(element.path);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InfoItem(
        title: idToTitle(element.id),
        subtitle: "Tomada " + timeago.format(f.lastModifiedSync()),
        file: f,
      ),
    );
  }

  static String idToTitle(String id) {
    return id.split("_")[0].capitalize() + ".";
  }
}
