class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final int targetKhatam;
  final DateTime? createdAt;
  final bool hasSeenTutorial;
  final bool hasSeenInitialTutorial;
  final double completedJuz;
  final double dailyJuzTarget; // Target juz harian yang dikunci

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.targetKhatam = 1,
    this.createdAt,
    this.hasSeenTutorial = false,
    this.hasSeenInitialTutorial = false,
    this.completedJuz = 0.0,
    this.dailyJuzTarget = 1.0,
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
      hasSeenInitialTutorial: map['hasSeenInitialTutorial'] ?? false,
      completedJuz: (map['completedJuz'] ?? 0.0).toDouble(),
      dailyJuzTarget: (map['dailyJuzTarget'] ??
              (map['targetKhatam'] != null ? map['targetKhatam'] * 1.0 : 1.0))
          .toDouble(),
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
      'hasSeenInitialTutorial': hasSeenInitialTutorial,
      'completedJuz': completedJuz,
      'dailyJuzTarget': dailyJuzTarget,
    };
  }

  /// Copy with untuk memudahkan update data
  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    int? targetKhatam,
    bool? hasSeenTutorial,
    bool? hasSeenInitialTutorial,
    double? completedJuz,
    double? dailyJuzTarget,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      targetKhatam: targetKhatam ?? this.targetKhatam,
      createdAt: createdAt,
      hasSeenTutorial: hasSeenTutorial ?? this.hasSeenTutorial,
      hasSeenInitialTutorial:
          hasSeenInitialTutorial ?? this.hasSeenInitialTutorial,
      completedJuz: completedJuz ?? this.completedJuz,
      dailyJuzTarget: dailyJuzTarget ?? this.dailyJuzTarget,
    );
  }
}
