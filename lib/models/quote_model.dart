class QuoteModel {
  final String id;
  final String content;
  final String source;
  final String type; // 'hadith', 'quran', 'reminder'

  QuoteModel({
    required this.id,
    required this.content,
    required this.source,
    required this.type,
  });

  factory QuoteModel.fromMap(String id, Map<String, dynamic> map) {
    return QuoteModel(
      id: id,
      content: map['content'] ?? '',
      source: map['source'] ?? '',
      type: map['type'] ?? 'reminder',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'source': source,
      'type': type,
    };
  }
}
