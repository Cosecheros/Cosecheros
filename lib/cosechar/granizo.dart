import 'package:cosecheros/forms/form_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class GranizoForm extends StatelessWidget {
  static const String URL = "https://mincyt-granizo.web.app/forms/granizo.1.json";

  Future<String> _getForm() async {
    var response = await http.get(Uri.parse(URL));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode != 200) {
      throw("Falla en la descarga");
    }
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      body: BaseForm(content: _getForm),
    );
  }
}
