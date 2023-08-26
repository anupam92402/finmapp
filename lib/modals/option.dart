class Option {
  String key;
  String value;

  Option({
    required this.key,
    required this.value,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      key: json['key'],
      value: json['value'],
    );
  }
}