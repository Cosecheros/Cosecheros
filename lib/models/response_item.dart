class ResponseItem {
  String id;
  String type;
  String label;
  dynamic value;

  ResponseItem({this.id, this.type, this.label, this.value});

  ResponseItem.fromJson(Map json) {
      id = json['id'] ?? '';
      type = json['type'] ?? '';
      label = json['label'] ?? '';
      value = json['value'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        if (label != null) 'label': label,
        if (value != null) 'value': value,
      };
}