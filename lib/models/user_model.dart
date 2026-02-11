class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final int targetKhatam;
  final DateTime? createdAt;
  final bool hasSeenTutorial;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.targetKhatam = 1,
    this.createdAt,
    this.hasSeenTutorial = false,
  });

  /// Konversi dari Map (Firestore) ke Object UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      targetKhatam: map['targetKhatam'] ?? 1,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : null,
      hasSeenTutorial: map['hasSeenTutorial'] ?? false,
    );
  }

  /// Konversi dari Object UserModel ke Map (untuk simpan ke Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'targetKhatam': targetKhatam,
      'createdAt': createdAt,
      'hasSeenTutorial': hasSeenTutorial,
    };
  }

  /// Copy with untuk memudahkan update data
  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    int? targetKhatam,
    bool? hasSeenTutorial,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      targetKhatam: targetKhatam ?? this.targetKhatam,
      createdAt: createdAt,
      hasSeenTutorial: hasSeenTutorial ?? this.hasSeenTutorial,
    );
  }
}
