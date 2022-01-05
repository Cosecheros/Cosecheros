import 'package:cosecheros/forms/form_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class OnlineForm extends StatelessWidget {
  final String url;
  OnlineForm(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      body: BaseForm(content: _getForm),
    );
  }

  Future<String> _getForm() async {
    var file = await DefaultCacheManager().getSingleFile(url);
    if (file == null) {
      throw ("Falla en la descarga");
    }
    return file.readAsString();
  }
}
