import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosecheros/forms/picture/pic_summary.dart';
import 'package:cosecheros/models/response_item.dart';
import 'package:cosecheros/widgets/info_item.dart';
import 'package:cosecheros/widgets/label_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cosecheros/shared/extensions.dart';

abstract class DetailWidget {
  Widget render(BuildContext context, ResponseItem item);
}

class NopeDetail extends DetailWidget {
  @override
  Widget render(BuildContext context, ResponseItem item) {
    return SizedBox.shrink();
  }
}

class BasicDetail extends DetailWidget {
  @override
  Widget render(BuildContext context, ResponseItem item) {
    return Text("${item.id}: ${item.value} as ${item.label}");
  }
}

class TextDetail extends DetailWidget {
  @override
  Widget render(BuildContext context, ResponseItem item) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InfoItem(
        title: item.label ?? 'Observaciones',
        subtitle: item.value,
      ),
    );
  }
}

class SingleChoiceDetail extends DetailWidget {
  @override
  Widget render(BuildContext context, ResponseItem item) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InfoItem(
        title: item.label,
        subtitle: item.value['label'] ?? '',
      ),
    );
  }
}

class MultiChoiceDetail extends DetailWidget {
  @override
  Widget render(BuildContext context, ResponseItem item) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InfoItem(
        title: item.label,
        childSubtitle: Column(
          children: [...item.value.map((e) => getItem(context, e))],
        ),
      ),
    );
  }

  Widget getItem(BuildContext context, Map<String, dynamic> element) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: Theme.of(context).colorScheme.primaryVariant,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              element['label'] ?? 'NS/NC',
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

class DateDetail extends DetailWidget {
  @override
  Widget render(BuildContext context, ResponseItem item) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InfoItem(
        title: item.label,
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
                  DateFormat.yMMMMEEEEd()
                      .addPattern("'a las'")
                      .add_Hm()
                      .format(item.value.toDate())
                      .capitalize(),
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

class PictureDetail extends DetailWidget {
  @override
  Widget render(BuildContext context, ResponseItem item) {
    return Card(
      elevation: 16,
      shadowColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
      margin: EdgeInsets.all(8),
      child: CachedNetworkImage(
        placeholder: (context, url) => Center(
          child: SizedBox(
            height: 30.0,
            width: 30.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primaryVariant,
              ),
            ),
          ),
        ),
        imageUrl: item.value,
        fit: BoxFit.cover,
        height: 300,
      ),
    );
  }
}
