import 'package:cosecheros/data/current_user.dart';
import 'package:cosecheros/data/database.dart';
import 'package:cosecheros/models/tweet.dart';
import 'package:cosecheros/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class TweetDetail extends StatelessWidget {
  final ScrollController scrollController;
  final String uid = CurrentUser.instance.data.uid;
  final String id;

  TweetDetail(this.id, this.scrollController);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Tweet>(
        stream:
            Database.instance.tuit(id).snapshots().map((event) => event.data()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final model = snapshot.data;
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
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                SizedBox(height: 16),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //   child: Row(
                //     children: [
                //       Icon(Icons.thumb_up_outlined),
                //       SizedBox(width: 8),
                //       Text(getTextVotes(model)),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: voteButtons(context, model),
                ),
              ],
            ),
          );
        });
  }

  String getTextVotes(Tweet model) {
    int votes = model.votesCount();
    if (votes == 0) {
      return "Nadie calificó este tuit";
    } else if (votes == 1) {
      return "Una persona votó";
    } else {
      return "${model.ups()} personas votaron";
    }
  }

  Row voteButtons(BuildContext context, Tweet model) {
    final currentVote = model.voteOf(CurrentUser.instance.data.uid);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: VoteButton(
            label: "Es útil (${model.ups()})",
            icon: Icons.thumb_up,
            isSelected: currentVote == 1,
            selected: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              await Database.instance.voteTuit(id, currentVote == 1 ? 0 : 1);
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: VoteButton(
            label: "Nada que ver (${model.downs()})",
            icon: Icons.thumb_down,
            isSelected: model.voteOf(CurrentUser.instance.data.uid) == -1,
            selected: Theme.of(context).colorScheme.error,
            onPressed: () async {
              await Database.instance.voteTuit(id, currentVote == -1 ? 0 : -1);
            },
          ),
        ),
      ],
    );
  }
}

class VoteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color selected;
  final double height;

  const VoteButton({
    Key key,
    this.onPressed,
    this.label,
    this.icon,
    this.isSelected,
    this.selected,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getDecorationBox(context),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Icon(icon, color: isSelected ? selected : Theme.of(context).colorScheme.onBackground),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w500,
                        color: isSelected
                            ? selected
                            : Theme.of(context).colorScheme.onBackground),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration getDecorationBox(BuildContext context) {
    return isSelected
        ? BoxDecoration(
            color: selected.withAlpha(12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 2,
              color: selected,
            ),
          )
        : BoxDecoration(
            color: Colors.black.withOpacity(.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 2,
              color: Colors.transparent,
            ),
          );
  }
}
