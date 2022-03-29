import 'package:flutter/material.dart';

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
    return TextButton(
      onPressed: this.onPressed,
      style: OutlinedButton.styleFrom(
          elevation: 4,
          shadowColor: background.withOpacity(0.4),
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
              padding: const EdgeInsets.all(8),
              child: icon ?? Icon(Icons.help_outline_rounded),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
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
