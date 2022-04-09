import 'package:flutter/material.dart';

class MultiChoiceWidget extends StatelessWidget {
  final ValueChanged<bool> onChanged;
  final String label;
  final bool isSelected;

  const MultiChoiceWidget({
    Key key,
    this.onChanged,
    this.label,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getDecorationBox(context, isSelected),
      clipBehavior: Clip.antiAlias,
      height: 80,
      child: InkWell(
        onTap: () {
          onChanged(!isSelected);
        },
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: <Widget>[
            Checkbox(
              onChanged: onChanged,
              value: isSelected,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onBackground),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration getDecorationBox(BuildContext context, bool value) {
    return value
        ? BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.primary,
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
