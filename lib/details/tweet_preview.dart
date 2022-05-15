import 'package:cosecheros/models/tweet.dart';
import 'package:cosecheros/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'tweet_detail.dart';

class TweetPreview extends StatelessWidget {
  final Tweet model;

  const TweetPreview(this.model);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
          ),
          builder: (BuildContext builder) {
            return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return TweetDetail(this.model, scrollController);
              },
            );
          },
        );
      },
      child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.keyboard_arrow_up_rounded),
              SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.event_type.capitalize() +
                        " " +
                        timeago.format(model.date),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Tuiteado por @" + model.screen_name,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: Colors.black87),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
