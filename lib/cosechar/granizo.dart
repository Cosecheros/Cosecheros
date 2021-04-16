import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as components;

/*

TODO
* crear componente para cada pantalla, una especie de "container" en TransitionDynamicForm

* crear componente para el Mapa
* crear componente para la fecha y hora
* intentar personalizar componente single choice
* crear componente para elegir foto
* crear componente con el resumen del formulario
* Manejar nosotros mismos el push del form (por las fotos)

* Crear Widget para la primera pantalla (y componente para el json)

*/

class GranizoForm extends StatefulWidget {
  GranizoForm({Key key}) : super(key: key);

  @override
  _GranizoFormState createState() => _GranizoFormState();
}

class _GranizoFormState extends State<GranizoForm> {
  bool isLoading = true;
  String json;


  @override
  void initState() {
    super.initState();
    // _buildForm();
  }

  // Future _buildForm() async {
  //   var doc = await Firestore.instance
  //               .collection('forms')
  //               .document('granizo')
  //               .get();
  //   print(doc.data);
  //   json = doc.data["data"];
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple dynamic form parsed from JSON'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: isLoading
              ? CircularProgressIndicator()
              : ParsedFormProvider(
                  create: (_) => JsonFormManager(),
                  content: json,
                  parsers: components.getDefaultParserList(),
                  child: FormRenderer<JsonFormManager>(
                    renderers: components.getRenderers(),
                  ),
                ),
        ),
      ),
    );
  }
}
