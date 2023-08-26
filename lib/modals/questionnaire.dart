import 'package:finmapp_task/modals/questionfield.dart';

class Questionnaire {
  String title;
  String name;
  String slug;
  String description;
  List<QuestionField> fields;

  // Private constructor
  Questionnaire._private({
    required this.title,
    required this.name,
    required this.slug,
    required this.description,
    required this.fields,
  });

  // Singleton instance
  static Questionnaire? instance;

  // Initialize the singleton instance using the factory constructor
  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    instance ??= Questionnaire._private(
      title: json['title'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      fields: List<QuestionField>.from(
        json['schema']['fields']
            .map((fieldJson) => QuestionField.fromJson(fieldJson)),
      ),
    );
    return instance!;
  }
}