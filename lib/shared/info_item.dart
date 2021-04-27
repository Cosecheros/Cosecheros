import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String img;
  final File file;
  final Widget child;

  InfoItem({
    @required this.title,
    @required this.subtitle,
    this.img,
    this.file,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(
              Size(double.infinity, 96),
            ),
            child: getPicture(),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.8),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getPicture() {
    if (img != null) {
      return CachedNetworkImage(
        imageUrl: img,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.info,
          color: Theme.of(context).colorScheme.primary,
          size: 56,
        ),
      );
    }
    if (file != null) {
      return Image.file(
        file,
        fit: BoxFit.cover,
      );
    }
    if (child != null) {
      return child;
    }
    return SizedBox();
  }
}
