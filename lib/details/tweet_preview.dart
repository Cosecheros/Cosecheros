import 'package:cosecheros/data/database.dart';
import 'package:cosecheros/models/tweet.dart';
import 'package:cosecheros/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'tweet_detail.dart';

class TweetPreview extends StatelessWidget {
  final String id;

  const TweetPreview(this.id);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tweet>(
        future: Database.instance.tuit(id).get().then((value) => value.data()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          }
          return InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Theme.of(context).colorScheme.background,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12.0)),
                ),
                builder: (BuildContext builder) {
                  return DraggableScrollableSheet(
                    expand: false,
                    builder: (context, scrollController) {
                      return TweetDetail(id, scrollController);
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
                          snapshot.data.event_type.capitalize() +
                              " " +
                              timeago.format(snapshot.data.date),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Tuiteado por @" + snapshot.data.screen_name,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.thumb_up_outlined,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    SizedBox(width: 4),
                    Text("${snapshot.data.sum()}"),
                  ],
                )),
          );
        });
  }
}
