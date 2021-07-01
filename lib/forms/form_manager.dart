import 'dart:collection';

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
    var formElements = getVisibleFormElementIterator<FormElement>().toList();

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

  static bool isData(propVal) =>
      propVal is MutableProperty &&
      !(propVal is Property<ExpressionProviderElement>) &&
      !(propVal is Property<List<ExpressionProviderElement>>);

  Iterable<TFE> getVisibleFormElementIterator<TFE extends FormElement>() sync* {
    var stack = Queue<FormElement>.from([form]);
    var visitedElements = {form};
    while (stack.isNotEmpty) {
      var formElement = stack.removeLast();
      visitedElements.add(formElement);
      if (formElement is TFE) {
        yield formElement;
      }
      var formElements = formElement
          .getProperties()
          .values
          .whereType<Property<FormElement>>()
          .map((v) => v.value)
          .where((element) => element.isVisible)
          .toList();

      var convertedNullableFormElements = formElement
          .getProperties()
          .values
          .whereType<Property<FormElement>>()
          .where((element) => element.value != null)
          .map((v) => v.value)
          .where((element) => element.isVisible)
          .toList();

      formElements.addAll(convertedNullableFormElements);

      var formListElements = formElement
          .getProperties()
          .values
          .whereType<Property<List<FormElement>>>()
          .map((v) => v.value)
          .expand((x) => x)
          .where((element) => element.isVisible);
      formElements.addAll(formListElements);

      formElements.forEach((e) {
        if (!visitedElements.contains(e)) {
          stack.addLast(e);
        }
      });
    }
  }
}
