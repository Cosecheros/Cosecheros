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

  // Behavior
  final bool scrollable;

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

    // Background
    this.backgroundColor,
    this.backgroundGradient,
    this.widgetBackground,

    // Behavior
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Colors.white,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: widgetBackground ??
            BoxDecoration(color: backgroundColor, gradient: backgroundGradient),
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0),
          child: listOrColumn(
            <Widget>[
              titleWidget(),
              descriptionWidget(),
              expandedOrNot(centerWidget)
            ],
          ),
        ),
      ),
    );
  }

  Widget listOrColumn(List children) {
    if (scrollable)
      return ListView(children: children);
    else
      return Column(children: children);
  }

  Widget expandedOrNot(Widget child) {
    if (child == null) return Container();
    if (scrollable)
      return child;
    else
      return Expanded(child: child);
  }

  Widget titleWidget() {
    if (widgetTitle != null || title != null)
      return Container(
        child: widgetTitle ??
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
              textAlign: TextAlign.center,
            ),
        margin:
            marginTitle ?? EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      );
    else
      return Container();
  }

  Widget descriptionWidget() {
    if (widgetDescription != null || description != null)
      return Container(
        child: widgetDescription ??
            Text(
              description,
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
        margin: marginDescription ??
            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      );
    else
      return Container();
  }
}
