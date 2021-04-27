import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosecheros/shared/info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';

import 'info.dart';

class InfoRenderer extends FormElementRenderer<Info> {
  @override
  Widget render(
      Info element,
      BuildContext context,
      FormElementEventDispatcherFunction dispatcher,
      FormElementRendererFunction renderer) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InfoItem(
        title: element.title,
        subtitle: element.subtitle,
        img: element.img,
      ),
    );
  }
}
