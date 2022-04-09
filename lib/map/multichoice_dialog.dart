import 'package:cosecheros/widgets/multichoice_widget.dart';
import 'package:flutter/material.dart';

class MultiChoiceDialog<T> extends StatefulWidget {
  const MultiChoiceDialog({Key key, this.options, this.selected})
      : super(key: key);

  final Map<String, T> options;
  final Set<T> selected;

  @override
  State<MultiChoiceDialog> createState() => _MultiChoiceDialogState<T>();
}

class _MultiChoiceDialogState<T> extends State<MultiChoiceDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(top: 24, left: 8, right: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '¿Qué quieres ver?',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 12),
            ...widget.options.entries.map(
              (entry) => Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: MultiChoiceWidget(
                  label: entry.key,
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        widget.selected.add(entry.value);
                      } else {
                        widget.selected.remove(entry.value);
                      }
                    });
                  },
                  isSelected: widget.selected.contains(entry.value),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text(
                  "APLICAR",
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  Navigator.pop(context, widget.selected);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
