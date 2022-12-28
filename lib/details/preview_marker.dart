import 'package:cosecheros/details/cosecha_preview.dart';
import 'package:cosecheros/details/tweet_preview.dart';
import 'package:cosecheros/map/MapMarker.dart';
import 'package:cosecheros/models/cosecha.dart';
import 'package:cosecheros/models/tweet.dart';
import 'package:flutter/material.dart';

class PreviewMarker extends StatelessWidget {
  final List<MapMarker> models;

  const PreviewMarker(this.models);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ...models.map((e) => toPreview(e)).toList(growable: false)
      ],
    );
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.1,
        minChildSize: 0,
        maxChildSize: 1,
        builder: (BuildContext context, ScrollController scrollController) {
          return ListView(
            controller: scrollController,
            shrinkWrap: true,
            children: [
              ...models.map((e) => toPreview(e)).toList(growable: false)
            ],
          );
        });
  }

  Widget toPreview(MapMarker marker) {
    dynamic model = marker.model;
    if (model == null) {
      return null;
    }
    if (model is Cosecha) {
      return CosechaPreview(model);
    }
    if (model is Tweet) {
      return TweetPreview(model.id);
    }
    return null;
  }
}
