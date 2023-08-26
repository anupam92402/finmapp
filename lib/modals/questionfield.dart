import 'fieldschema.dart';

class QuestionField {
  String type;
  int version;
  FieldSchema schema;

  QuestionField({
    required this.type,
    required this.version,
    required this.schema,
  });

  factory QuestionField.fromJson(Map<String, dynamic> json) {
    return QuestionField(
      type: json['type'],
      version: json['version'],
      schema: FieldSchema.fromJson(json['schema']),
    );
  }
}