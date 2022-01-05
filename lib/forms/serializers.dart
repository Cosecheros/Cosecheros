import 'package:cosecheros/forms/info/info.dart';
import 'package:cosecheros/forms/map/map.dart' as mapModel;
import 'package:cosecheros/forms/multichoice/multichoice_group.dart';
import 'package:cosecheros/forms/picture/pic.dart';
import 'package:cosecheros/forms/singlechoice/singlechoice_group.dart';
import 'package:cosecheros/models/response_item.dart';
import 'package:cosecheros/shared/helpers.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as model;
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart';

final Map<Type, Serializer> serializers = {
  Picture: PictureSerializer(),
  SingleChoiceGroup: SingleChoiceSerializer(),
  MultiChoiceGroup: MultiChoiceSerializer(),
  model.CheckBox: null,
  mapModel.Map: MapSerializer(),
  model.TextField: TextSerializer(),
  model.Date: DateSerializer(),
  // Ignore
  model.SingleSelectChoice: NopeSerializer(),
  model.MultiSelectChoice: NopeSerializer(),
  model.Label: NopeSerializer(),
  model.FormGroup: NopeSerializer(),
  model.Form: NopeSerializer(),
  Info: NopeSerializer(),
};

class BasicSerializer extends Serializer<FormElement> {
  @override
  ResponseItem serialize(FormElement element) {
    var valueProperty = element.getProperties()['value'];
    if (valueProperty == null) return null;
    return ResponseItem(
      id: element.id,
      type: element.runtimeType.toString(),
      label: element.getProperties()['label'].value,
      value: valueProperty.value,
    );
  }
}

class DateSerializer extends Serializer<model.Date> {
  @override
  ResponseItem serialize(model.Date element) {
    return ResponseItem(
      id: element.id,
      type: 'date',
      label: element.label,
      value: element.value,
    );
  }
}

class MapSerializer extends Serializer<mapModel.Map> {
  @override
  ResponseItem serialize(mapModel.Map element) {
    return ResponseItem(
      id: element.id,
      type: 'geo_point',
      // label: element.label, TODO: guardar el "cerca de" acá?
      value: geoPoinFromGeoPos(element.point),
    );
  }
}

class MultiChoiceSerializer extends Serializer<MultiChoiceGroup> {
  @override
  ResponseItem serialize(MultiChoiceGroup element) {
    var selected = element.choices
        .where((element) => element.isSelected)
        .map(
          (e) => {
            'id': e.id,
            'label': e.label,
          },
        )
        .toList();
    if (selected == null) return null;
    return ResponseItem(
      id: element.id,
      type: 'multi_choice',
      label: element.label,
      value: selected,
    );
  }
}

class NopeSerializer extends Serializer<FormElement> {
  @override
  ResponseItem serialize(FormElement element) {
    return null;
  }
}

class PictureSerializer extends Serializer<Picture> {
  @override
  ResponseItem serialize(Picture element) {
    if (element.url == null) return null;
    return ResponseItem(
      id: element.id,
      type: 'picture',
      // label: element.label,
      value: element.url,
    );
  }
}

abstract class Serializer<T extends FormElement> {
  ResponseItem serialize(T element);
}

class SingleChoiceSerializer extends Serializer<SingleChoiceGroup> {
  @override
  ResponseItem serialize(SingleChoiceGroup element) {
    var selected = element.choices.singleWhere(
      (choice) => choice.value == element.value,
      orElse: () => null,
    );
    if (selected == null) return null;
    return ResponseItem(
      id: element.id,
      type: 'single_choice',
      label: element.label,
      value: {
        'id': selected.value,
        'label': selected.label,
      },
    );
  }
}

class TextSerializer extends Serializer<TextField> {
  @override
  ResponseItem serialize(TextField element) {
    if (element.value.isEmpty) return null;
    return ResponseItem(
      id: element.id,
      type: 'text',
      label: element.label,
      value: element.value,
    );
  }
}
