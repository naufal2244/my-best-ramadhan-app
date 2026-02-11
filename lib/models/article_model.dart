class ArticleModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final String duration; // e.g., "5:30"

  ArticleModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
  });

  factory ArticleModel.fromMap(String id, Map<String, dynamic> map) {
    return ArticleModel(
      id: id,
      title: map['title'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      duration: map['duration'] ?? '0:00',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'duration': duration,
    };
  }
}
