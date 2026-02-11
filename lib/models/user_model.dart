class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final int targetKhatam;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.targetKhatam = 1,
    this.createdAt,
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
    };
  }

  /// Copy with untuk memudahkan update data
  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    int? targetKhatam,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      targetKhatam: targetKhatam ?? this.targetKhatam,
      createdAt: createdAt,
    );
  }
}
