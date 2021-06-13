import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LabelWidget extends StatelessWidget {
  final text;
  LabelWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
