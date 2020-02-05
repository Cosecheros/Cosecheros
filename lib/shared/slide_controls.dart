import 'package:flutter/material.dart';

enum dotSliderAnimation { SIZE_TRANSITION, DOT_MOVEMENT }

class SlideControls extends StatefulWidget {

  final Function onDonePress;
  final TabController controller;
  final List<bool> nextEnabled;

  // ---------- Dot indicator ----------
  final Color colorDot;
  final Color colorActiveDot;
  final double sizeDot;
  final dotSliderAnimation typeDotAnimation;

  SlideControls({
    this.onDonePress,
    @required this.controller,
    @required this.nextEnabled,

    // Dots
    this.colorDot = const Color(0x80000000),
    this.colorActiveDot = const Color(0x80000000),
    this.sizeDot = 8.0,
    this.typeDotAnimation = dotSliderAnimation.DOT_MOVEMENT,

  });

  @override
  State<SlideControls> createState() => SliderControlsState();
}

class SliderControlsState extends State<SlideControls>
    with SingleTickerProviderStateMixin {

  /// Default values
  static const TextStyle defaultBtnNameTextStyle =
      TextStyle(color: Colors.white);
  static const double defaultBtnBorderRadius = 30.0;
  static const Color defaultBtnColor = Colors.transparent;
  static const Color defaultBtnHighlightColor = const Color(0x4dffffff);

  List<Widget> dots = new List();
  List<double> sizeDots = new List();
  List<double> opacityDots = new List();

  // For DOT_MOVEMENT
  double marginLeftDotFocused = 0;
  double marginRightDotFocused = 0;

  // For SIZE_TRANSITION
  double currentAnimationValue = 0;
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();

    double sizeDot = widget.sizeDot;

    widget.controller.addListener(() {
      if (widget.controller.indexIsChanging) {
        currentTabIndex = widget.controller.previousIndex;
      } else {
        currentTabIndex = widget.controller.index;
      }
      currentAnimationValue = widget.controller.animation.value;
    });

    double initValueMarginRight = (sizeDot * 2) * (widget.nextEnabled.length - 1);

    switch (widget.typeDotAnimation) {
      case dotSliderAnimation.DOT_MOVEMENT:
        for (int i = 0; i < widget.nextEnabled.length; i++) {
          sizeDots.add(sizeDot);
          opacityDots.add(1.0);
        }
        marginRightDotFocused = initValueMarginRight;
        break;
      case dotSliderAnimation.SIZE_TRANSITION:
        for (int i = 0; i < widget.nextEnabled.length; i++) {
          if (i == 0) {
            sizeDots.add(sizeDot * 1.5);
            opacityDots.add(1.0);
          } else {
            sizeDots.add(sizeDot);
            opacityDots.add(0.5);
          }
        }
    }

    widget.controller.animation.addListener(() {
      this.setState(() {
        switch (widget.typeDotAnimation) {
          case dotSliderAnimation.DOT_MOVEMENT:
            marginLeftDotFocused = widget.controller.animation.value * sizeDot * 2;
            marginRightDotFocused = initValueMarginRight -
                widget.controller.animation.value * sizeDot * 2;
            break;
          case dotSliderAnimation.SIZE_TRANSITION:
            if (widget.controller.animation.value == currentAnimationValue) {
              break;
            }

            double diffValueAnimation =
                (widget.controller.animation.value - currentAnimationValue).abs();
            int diffValueIndex = (currentTabIndex - widget.controller.index).abs();

            // When press skip button
            if (widget.controller.indexIsChanging &&
                (widget.controller.index - widget.controller.previousIndex).abs() > 1) {
              if (diffValueAnimation < 1.0) {
                diffValueAnimation = 1.0;
              }
              sizeDots[currentTabIndex] = sizeDot * 1.5 -
                  (sizeDot / 2) * (1 - (diffValueIndex - diffValueAnimation));
              sizeDots[widget.controller.index] = sizeDot +
                  (sizeDot / 2) * (1 - (diffValueIndex - diffValueAnimation));
              opacityDots[currentTabIndex] =
                  1.0 - (diffValueAnimation / diffValueIndex) / 2;
              opacityDots[widget.controller.index] =
                  0.5 + (diffValueAnimation / diffValueIndex) / 2;
            } else {
              if (widget.controller.animation.value > currentAnimationValue) {
                // Swipe left
                sizeDots[currentTabIndex] =
                    sizeDot * 1.5 - (sizeDot / 2) * diffValueAnimation;
                sizeDots[currentTabIndex + 1] =
                    sizeDot + (sizeDot / 2) * diffValueAnimation;
                opacityDots[currentTabIndex] = 1.0 - diffValueAnimation / 2;
                opacityDots[currentTabIndex + 1] = 0.5 + diffValueAnimation / 2;
              } else {
                // Swipe right
                sizeDots[currentTabIndex] =
                    sizeDot * 1.5 - (sizeDot / 2) * diffValueAnimation;
                sizeDots[currentTabIndex - 1] =
                    sizeDot + (sizeDot / 2) * diffValueAnimation;
                opacityDots[currentTabIndex] = 1.0 - diffValueAnimation / 2;
                opacityDots[currentTabIndex - 1] = 0.5 + diffValueAnimation / 2;
              }
            }
            break;
        }
      });
    });
  }

  // Checking if tab is animating
  bool isAnimating() {
    return widget.controller.animation.value -
        widget.controller.animation.value.truncate() !=
        0;
  }

  @override
  Widget build(BuildContext context) {
    return renderBottom();
  }

  Widget buildDoneButton() {
    return FlatButton(
      onPressed: widget.onDonePress,
      child: Text(
        "FINALIZAR",
        style: defaultBtnNameTextStyle,
      ),
      color: defaultBtnColor,
      highlightColor: defaultBtnHighlightColor,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(defaultBtnBorderRadius)),
    );
  }

  Widget buildPrevButton() {
    if (widget.controller.index == 0) {
      return Container(width: MediaQuery.of(context).size.width / 4);
    } else {
      return FlatButton(
        child: Text(
          "PREV",
          style: defaultBtnNameTextStyle,
        ),
        onPressed: () {
          if (!this.isAnimating()) {
            widget.controller.animateTo(widget.controller.index - 1);
          }
        },
        color: defaultBtnColor,
        highlightColor: defaultBtnHighlightColor,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(defaultBtnBorderRadius)),
      );
    }
  }

  Widget buildNextButton() {
    return FlatButton(
      child: Text(
        "SIGUIENTE",
        style: defaultBtnNameTextStyle,
      ),
      onPressed: widget.nextEnabled[widget.controller.index]
          ? () {
              if (!this.isAnimating()) {
                widget.controller.animateTo(widget.controller.index + 1);
              }
            }
          : null,
      color: defaultBtnColor,
      highlightColor: defaultBtnHighlightColor,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(defaultBtnBorderRadius)),
    );
  }

  Widget renderBottom() {
    return Positioned(
      child: Row(
        children: <Widget>[
          // Skip button
          Container(
            alignment: Alignment.center,
            child: buildPrevButton(),
            width: MediaQuery.of(context).size.width / 4,
          ),

          // Dot indicator
          Flexible(
              child: Container(
            child: Stack(
              children: <Widget>[
                Row(
                  children: this.renderListDots(),
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                widget.typeDotAnimation == dotSliderAnimation.DOT_MOVEMENT
                    ? Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: widget.colorActiveDot,
                              borderRadius:
                                  BorderRadius.circular(widget.sizeDot / 2)),
                          width: widget.sizeDot,
                          height: widget.sizeDot,
                          margin: EdgeInsets.only(
                              left: marginLeftDotFocused,
                              right: marginRightDotFocused),
                        ),
                      )
                    : Container()
              ],
            ),
          )),

          // Next, Done button
          Container(
            alignment: Alignment.center,
            child: widget.controller.index + 1 == widget.nextEnabled.length
                ? buildDoneButton()
                : buildNextButton(),
            width: MediaQuery.of(context).size.width / 4,
          ),
        ],
      ),
      bottom: 10.0,
      left: 10.0,
      right: 10.0,
    );
  }

  List<Widget> renderListDots() {
    dots.clear();
    for (int i = 0; i < widget.nextEnabled.length; i++) {
      dots.add(renderDot(sizeDots[i], widget.colorDot, opacityDots[i]));
    }
    return dots;
  }

  Widget renderDot(double radius, Color color, double opacity) {
    return Opacity(
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(radius / 2)),
        width: radius,
        height: radius,
        margin: EdgeInsets.only(left: radius / 2, right: radius / 2),
      ),
      opacity: opacity,
    );
  }
}
