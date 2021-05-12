import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:expression_language/expression_language.dart';

class CustomFormManager extends JsonFormManager {
  List<FormElement> getElementsData() {
    return getFormElementIterator<FormElement>(form)
        .where(
          (e) => e.getProperties().values.any((prop) => isData(prop)),
        )
        .toList();
  }

  List<Map<String, dynamic>> getFormData() {
    var result = <Map<String, dynamic>>[];
    var formElements = getFormElementIterator<FormElement>(form).toList();

    formElements.forEach((fe) {
      var properties = fe.getProperties();
      properties.forEach((name, propVal) {
        if (isData(propVal)) {
          Map<String, dynamic> item = {
            "name": name,
            "value": propVal.value,
            "formElement": fe
          };
          result.add(item);
        }
      });
    });
    return result;
  }

  bool isData(propVal) =>
      propVal is MutableProperty &&
      !(propVal is Property<ExpressionProviderElement>) &&
      !(propVal is Property<List<ExpressionProviderElement>>);
}
