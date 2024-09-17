import 'dart:convert';

class HashTags {
  final String id;
  final String text;
  final int count;
  HashTags({
    required this.id,
    required this.text,
    required this.count,
  });

  HashTags copyWith({
    String? id,
    String? text,
    int? count,
  }) {
    return HashTags(
      id: id ?? this.id,
      text: text ?? this.text,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'count': count,
    };
  }

  factory HashTags.fromMap(Map<String, dynamic> map) {
    return HashTags(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      count: map['count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory HashTags.fromJson(String source) => HashTags.fromMap(json.decode(source));

  @override
  String toString() => 'HashTag(id: $id, text: $text, count: $count)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HashTags && other.id == id && other.text == text && other.count == count;
  }

  @override
  int get hashCode => id.hashCode ^ text.hashCode ^ count.hashCode;
}
