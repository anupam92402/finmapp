import 'package:finmapp_task/modals/questionfield.dart';

import 'option.dart';

class FieldSchema {
  String name;
  String label;
  bool? hidden;
  bool? readonly;
  List<Option>? options;
  List<QuestionField>? fields;

  FieldSchema({
    required this.name,
    required this.label,
    this.hidden,
    this.readonly,
    this.options,
    this.fields,
  });

  factory FieldSchema.fromJson(Map<String, dynamic> json) {
    bool? hidden = evaluateExpression(json['hidden']);
    return FieldSchema(
      name: json['name'],
      label: json['label'],
      hidden: hidden,
      readonly: json['readonly'],
      options: (json['options'] != null)
          ? List<Option>.from(
              json['options'].map((optionJson) => Option.fromJson(optionJson)))
          : null,
      fields: (json['fields'] != null)
          ? List<QuestionField>.from(json['fields']
              .map((fieldJson) => QuestionField.fromJson(fieldJson)))
          : null,
    );
  }
}

bool? evaluateExpression(dynamic hidden) {
  if (hidden == null || hidden.runtimeType == bool) {
    return hidden;
  }
  return true;
}