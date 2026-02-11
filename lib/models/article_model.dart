class ArticleModel {
  final String id;
  final String title;
  final String? description;
  final String thumbnailUrl;
  final String videoUrl;
  final String duration; // e.g., "5:30"
  final DateTime? publishedAt;

  ArticleModel({
    required this.id,
    required this.title,
    this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    this.publishedAt,
  });

  factory ArticleModel.fromMap(String id, Map<String, dynamic> map) {
    return ArticleModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'],
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      duration: map['duration'] ?? '0:00',
      publishedAt: map['publishedAt'] != null
          ? (map['publishedAt'] as dynamic).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'duration': duration,
      'publishedAt': publishedAt,
    };
  }
}
