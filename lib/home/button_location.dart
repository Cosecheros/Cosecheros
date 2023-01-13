import 'package:flutter/material.dart';

class ButtonLocation extends StatelessWidget {
  const ButtonLocation({Key key, this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      mini: true,
      backgroundColor: Colors.white,
      child: Icon(
        Icons.gps_fixed,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: onPressed,
    );
  }
}
