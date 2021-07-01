import 'package:cosecheros/map/details_widgets.dart';
import 'package:cosecheros/models/cosecha.dart';
import 'package:cosecheros/models/response_item.dart';
import 'package:flutter/material.dart';
import 'package:cosecheros/shared/extensions.dart';

import 'package:timeago/timeago.dart' as timeago;

class CosechaDetail extends StatelessWidget {
  final Cosecha model;
  final ScrollController scrollController;
  CosechaDetail(this.model, this.scrollController);

  final Map<String, DetailWidget> builders = {
    'picture': PictureDetail(),
    'single_choice': SingleChoiceDetail(),
    'multi_choice': MultiChoiceDetail(),
    'geo_point': NopeDetail(),
    'text': TextDetail(),
    'date': DateDetail(),
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        controller: scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              "${model.alias}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .textTheme
                      .headline6
                      .color
                      .withOpacity(0.8)),
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Por ${model.username}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .color
                    .withOpacity(0.9)),
          ),
          SizedBox(height: 4),
          Text(
            "${timeago.format(model.timestamp).capitalize()}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .color
                      .withOpacity(0.7),
                ),
          ),
          SizedBox(height: 16),
          buildPictures(context,
              model.payload.where((e) => e.type == 'picture').toList()),
          ...model.payload
              .where((e) => e.type != 'picture')
              .map((item) => _toDetail(context, item))
              .where((e) => e != null)
        ],
      ),
    );
  }

  Widget _toDetail(BuildContext context, ResponseItem item) {
    print("_toDetail: " + item.toString());
    DetailWidget builder = builders[item.type];

    if (builder is NopeDetail) {
      return null;
    }

    if (builder != null) {
      return builder.render(context, item);
    }
    print("ERROR: No hay detail implementado: $item");
    return Text("Otra opción: ${item.type}");
  }

  Widget buildPictures(BuildContext context, List items) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: items.map((e) => _toDetail(context, e)).toList(),
      ),
    );
    // return ListView(
    //   controller: scrollController,
    //   scrollDirection: Axis.horizontal,
    //   children: ,
    // );
  }
}
