import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {

  final bool value;
  final String label;
  final VoidCallback onTap;

  const ChoiceButton({Key key, this.value, this.label, this.onTap}) : super(key: key);


  BoxDecoration getDecorationBox(context) {
    return value
        ? BoxDecoration(
            color: Theme.of(context).colorScheme.primaryVariant.withAlpha(12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.primaryVariant,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      // margin: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 4),
      decoration: getDecorationBox(context),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontWeight: value
                      ? FontWeight.w800
                      : FontWeight.w500,
                  color: value
                      ? Theme.of(context).colorScheme.primaryVariant
                      : Theme.of(context).colorScheme.onBackground),
            ),
          ),
        ),
      ),
    );
  }
}
