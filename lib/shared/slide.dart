import 'package:flutter/material.dart';

class Slide extends StatelessWidget {
  // Title
  final Widget widgetTitle;
  final String title;
  final EdgeInsetsGeometry marginTitle;

  final Widget centerWidget;

  // Description
  final String description;
  final EdgeInsets marginDescription;
  final Widget widgetDescription;

  // Background
  final Color backgroundColor;
  final LinearGradient backgroundGradient;
  final BoxDecoration widgetBackground;

  Slide({
    // Title
    this.widgetTitle,
    this.title,
    this.marginTitle,

    // Center widget
    this.centerWidget,

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
                  LinearGradient(colors: [backgroundColor, backgroundColor])),
      child: Container(
        margin: EdgeInsets.only(bottom: 60.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              // Title
              child: widgetTitle ?? title != null
                  ? Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Container(),
              margin: marginTitle ??
                  EdgeInsets.only(
                      top: 70.0, bottom: 20.0, left: 20.0, right: 20.0),
            ),
            // Description
            Container(
              child: widgetDescription ?? (description != null
                  ? Text(
                      description,
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                      textAlign: TextAlign.center,
                      maxLines: 100,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Container()),
              margin: marginDescription ??
                  EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
            Expanded(
              child: centerWidget ?? Container(),
            )
          ],
        ),
      ),
    );
  }
}
