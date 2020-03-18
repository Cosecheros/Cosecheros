import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/harvest.dart';

class HarvestCard extends StatelessWidget {
  final HarvestModel model;

  HarvestCard(this.model);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(bottom: 12),
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            showImage(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.black26,
                highlightColor: Colors.black26,
                onTap: () {
                  // TODO: mostrar imagen en pantalla completa?
                  print('Card tapped.');
                },
                child: Container(
                    alignment: Alignment.bottomLeft,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.black.withAlpha(0),
                          Colors.black12,
                          Colors.black38
                        ],
                      ),
                    ),
                    child: showText()),
              ),
            )
          ],
        ));
  }

  Widget showImage() => model.stormThumb == null
      ? Container()
      : CachedNetworkImage(
          placeholder: (context, url) => Center(
            child: SizedBox(
              height: 30.0,
              width: 30.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).accentColor),
              ),
            ),
          ),
          imageUrl: model.stormThumb,
          fit: BoxFit.cover,
          height: 200,
        );

  Widget showText() => ListTile(
        title: Text(
          DateFormat.yMMMMd().format(model.dateTime),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: Text(rainToString(model.rain),
            style: TextStyle(
              color: Colors.white,
            )),
      );
}
