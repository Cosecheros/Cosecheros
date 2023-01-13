import 'dart:async';

import 'package:flutter/material.dart';

class ButtonFilters extends StatelessWidget {
  const ButtonFilters({Key key, this.controller}) : super(key: key);

  final StreamController controller;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      mini: true,
      backgroundColor: Colors.white,
      child: Icon(
        Icons.filter_list_rounded,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      onPressed: () {
        showFilter(context);
      },
    );
  }

  void showFilter(context) async {
    var selected = await showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Duration(hours: 12));
              },
              child: const Text('Últimas 12 horas'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Duration(days: 1));
              },
              child: const Text('Último día'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Duration(days: 7));
              },
              child: const Text('Últimos 7 días'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Duration(days: 30));
              },
              child: const Text('Último mes'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Duration(days: 31 * 6));
              },
              child: const Text('Últimos 6 meses'),
            ),
          ],
        );
      },
    );
    print("Filters: ${selected.inDays}");
    controller.sink.add(selected);
  }
}