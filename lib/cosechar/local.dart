import 'package:cosecheros/forms/form_base.dart';
import 'package:cosecheros/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      body: BaseForm(
        content: () => rootBundle
            .loadString('firebase/hosting/forms/${Constants.localForm}.json'),
      ),
    );
  }
}
