import 'package:flutter/material.dart';


class MapRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child:
        Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),
            RaisedButton(
              child: Text('DatePicker'),
              onPressed: () {
                Future<DateTime> selectedDate = showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2010),
                  lastDate: DateTime.now(),
                );

                selectedDate.then((v) {
                  print(v);
                }, onError: (){
                  print("errorerror");
                });

              },
            ),
            RaisedButton(
              child: Text('ImagePicker'),
              onPressed: () {}
            ),

            RainOptionsWidget(),

          ],
        )
      ),
    );
  }
}


enum RainOptions { before, during, after }

class RainOptionsWidget extends StatefulWidget {
  RainOptionsWidget({Key key}) : super(key: key);

  @override
  _RainOptionsState createState() => _RainOptionsState();
}

class _RainOptionsState extends State<RainOptionsWidget> {
  RainOptions _selected = RainOptions.before;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile<RainOptions>(
          title: const Text('Antes del granizo'),
          value: RainOptions.before,
          groupValue: _selected,
          onChanged: (RainOptions value) {
            setState(() {
              _selected = value;
            });
          },
        ),
        RadioListTile<RainOptions>(
          title: const Text('Durante el granizo'),
          value: RainOptions.during,
          groupValue: _selected,
          onChanged: (RainOptions value) {
            setState(() {
              _selected = value;
            });
          },
        ),
        RadioListTile<RainOptions>(
          title: const Text('Despues del granizo'),
          value: RainOptions.after,
          groupValue: _selected,
          onChanged: (RainOptions value) {
            setState(() {
              _selected = value;
            });
          },
        ),
      ],
    );
  }
}
