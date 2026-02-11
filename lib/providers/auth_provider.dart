import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _userData;
  bool _isLoading = false;

  UserModel? get userData => _userData;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  AuthProvider() {
    // Pantau status login secara otomatis saat provider dibuat
    _authService.userStream.listen((User? user) async {
      if (user != null) {
        await fetchUserData(user.uid);
      } else {
        _userData = null;
        notifyListeners();
      }
    });
  }

  /// Ambil data detail user dari Firestore
  Future<void> fetchUserData(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userData = await _authService.getUserData(uid);
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.loginWithEmail(email, password);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Register
  Future<void> register(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.registerWithEmail(email, password, name);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout() async {
    await _authService.signOut();
    _userData = null;
    notifyListeners();
  }

  /// Update Nama Profil
  Future<void> updateProfileName(String newName) async {
    if (_userData == null) return;

    try {
      await _firestore.collection('users').doc(_userData!.uid).update({
        'displayName': newName,
      });
      _userData = _userData!.copyWith(displayName: newName);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Update Target Khatam
  Future<void> updateTargetKhatam(int newTarget) async {
    if (_userData == null) return;

    try {
      await _firestore.collection('users').doc(_userData!.uid).update({
        'targetKhatam': newTarget,
      });
      _userData = _userData!.copyWith(targetKhatam: newTarget);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Update Status Tutorial
  Future<void> setHasSeenTutorial(bool seen) async {
    if (_userData == null) return;

    try {
      await _firestore.collection('users').doc(_userData!.uid).update({
        'hasSeenTutorial': seen,
      });
      _userData = _userData!.copyWith(hasSeenTutorial: seen);
      notifyListeners();
    } catch (e) {
      debugPrint("Error updating tutorial status: $e");
    }
  }

  /// Ganti Password
  Future<void> updatePassword(String newPassword) async {
    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
    } catch (e) {
      rethrow;
    }
  }
}
