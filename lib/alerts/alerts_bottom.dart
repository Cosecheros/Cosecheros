import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AlertsBottom extends StatefulWidget {
  AlertsBottom({Key key}) : super(key: key);

  @override
  _AlertsBottomState createState() => _AlertsBottomState();
}

class _AlertsBottomState extends State<AlertsBottom> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(Icons.arrow_upward_rounded),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("¡Alerta del servicio metereologico!"),
              Text("Hace 20 minutos"),
            ],
          ),
        ),
        Icon(Icons.notification_important_rounded)
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
