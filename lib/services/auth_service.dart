import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream untuk memantau perubahan status login user
  Stream<User?> get userStream => _auth.authStateChanges();

  /// Register user baru dengan email & password
  Future<UserCredential> registerWithEmail(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan data tambahan ke Firestore
      if (result.user != null) {
        UserModel newUser = UserModel(
          uid: result.user!.uid,
          email: email,
          displayName: name,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(result.user!.uid)
            .set(newUser.toMap());
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  /// Login dengan email & password
  Future<UserCredential> loginWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Login dengan Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Check if this is a new user and create Firestore document if needed
      if (userCredential.user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          // New user - create Firestore document
          UserModel newUser = UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            displayName: userCredential.user!.displayName ?? 'User',
            photoUrl: userCredential.user!.photoURL,
            createdAt: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(newUser.toMap());
        }
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  /// Logout
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  /// Ambil data user dari Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Hapus Akun & Semua Data Terkait
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final uid = user.uid;

      // 1. Hapus sub-koleksi 'habits'
      final habits = await _firestore
          .collection('users')
          .doc(uid)
          .collection('habits')
          .get();
      for (var doc in habits.docs) {
        await doc.reference.delete();
      }

      // 2. Hapus sub-koleksi 'bookmarks'
      final bookmarks = await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookmarks')
          .get();
      for (var doc in bookmarks.docs) {
        await doc.reference.delete();
      }

      // 3. Hapus dokumen utama user
      await _firestore.collection('users').doc(uid).delete();

      // 4. Hapus sesi Google Sign In agar tidak otomatis login lagi
      await GoogleSignIn().signOut();

      // 5. Hapus user dari Firebase Auth
      await user.delete();
    } catch (e) {
      rethrow;
    }
  }
}
