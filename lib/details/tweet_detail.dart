import 'package:cosecheros/details/details_widgets.dart';
import 'package:cosecheros/models/tweet.dart';
import 'package:cosecheros/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class TweetDetail extends StatelessWidget {
  final Tweet model;
  final ScrollController scrollController;
  final Map<String, DetailWidget> builders = {
    'picture': PictureDetail(),
    'single_choice': SingleChoiceDetail(),
    'multi_choice': MultiChoiceDetail(),
    'geo_point': NopeDetail(),
    'text': TextDetail(),
    'date': DateDetail(),
  };

  TweetDetail(this.model, this.scrollController);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        controller: scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              "${model.event_type.capitalize()}",
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
            "Por @${model.screen_name}",
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
            "${timeago.format(model.date).capitalize()}",
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Linkify(
              text: model.text,
              onOpen: (link) async {
                if (await canLaunch(link.url)) {
                  await launch(link.url);
                }
              },
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .color
                        .withOpacity(0.8),
                  ),
            ),
          )
        ],
      ),
    );
  }
}
