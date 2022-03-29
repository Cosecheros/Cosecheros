import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String url;
  final File file;
  final Widget childImage;
  final Widget childSubtitle;

  InfoItem({
    @required this.title,
    this.subtitle,
    this.url,
    this.file,
    this.childImage,
    this.childSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: (url ?? file ?? childImage) == null ? 0 : 8,
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
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              ..._getSubtitle(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget getPicture() {
    if (url != null) {
      return CachedNetworkImage(
        imageUrl: url,
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
    if (childImage != null) {
      return childImage;
    }
    return SizedBox.shrink();
  }

  List<Widget> _getSubtitle(BuildContext context) {
    return [
      if (subtitle != null || childSubtitle != null) SizedBox(height: 8),
      if (subtitle != null)
        Text(subtitle,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .color
                      .withOpacity(0.8),
                )),
      if (childSubtitle != null) childSubtitle
    ];
  }
}
