import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:dynamic_forms/dynamic_forms.dart';

class SumaryPage extends StatelessWidget {
  const SumaryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var props = FormProvider.of<JsonFormManager>(context).getFormProperties();
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 64),
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: props
              .map((i) => Text(
                    '${i.id} = ${i.property}: ${i.value}',
                    style: Theme.of(context).textTheme.bodyText1.apply(
                        color: i.value == "false" || i.value == ""
                            ? Colors.red
                            : Colors.green),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
