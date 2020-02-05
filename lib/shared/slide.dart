import 'package:flutter/material.dart';

class Slide extends StatelessWidget {

  // Title
  final Widget widgetTitle;
  final String title;
  final EdgeInsetsGeometry marginTitle;

  // Image
  final String pathImage;
  final double widthImage;
  final double heightImage;

  /// Scale of image
  final BoxFit foregroundImageFit;
  final Function onCenterItemPress;

  final Widget centerWidget;

  // Description widget
  /// If non-null, used instead of [description] and its relevant properties
  final Widget widgetDescription;

  // Description
  final String description;

  /// Margin for text description
  final EdgeInsets marginDescription;

  // Background color
  final Color backgroundColor;
  final LinearGradient backgroundGradient;

  // Background image
  final BoxDecoration widgetBackground;

  Slide({
    // Title
    this.widgetTitle,
    this.title,
    this.marginTitle,

    // Image
    this.pathImage,
    this.widthImage,
    this.heightImage,
    this.foregroundImageFit,

    // Center widget
    this.centerWidget,
    this.onCenterItemPress,

    // Description
    this.widgetDescription,
    this.description,
    this.marginDescription,

    // Background color
    this.backgroundColor,
    this.backgroundGradient,

    // background image
    this.widgetBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: widgetBackground ??
          BoxDecoration(
              gradient: backgroundGradient ??
                  LinearGradient(colors: [
                    backgroundColor,
                    backgroundColor
                  ])),
      child: Container(
        margin: EdgeInsets.only(bottom: 60.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              // Title
              child: widgetTitle ??
                  Text(
                    title ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
              margin: marginTitle ??
                  EdgeInsets.only(
                      top: 70.0, bottom: 20.0, left: 20.0, right: 20.0),
            ),

            centerWidget ?? Container(),

            // Description
            Container(
              child: widgetDescription ??
                  Text(
                    description ?? "",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    textAlign: TextAlign.center,
                    maxLines: 100,
                    overflow: TextOverflow.ellipsis,
                  ),
              margin: marginDescription ??
                  EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
          ],
        ),
      ),
    );
  }
}
