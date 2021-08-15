import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GridIconButton extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onPressed;
  final Color background;
  const GridIconButton({
    this.title = "title",
    this.icon,
    this.onPressed,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: this.onPressed,
      style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          backgroundColor: background ?? Colors.blue,
          primary: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: icon ?? Icon(Icons.help_outline_rounded),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 16),
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
