import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/article_model.dart';

class FeedProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ArticleModel> _articles = [];
  List<String> _bookmarkIds = [];
  bool _isLoading = false;

  List<ArticleModel> get articles => _articles;
  List<String> get bookmarkIds => _bookmarkIds;
  bool get isLoading => _isLoading;

  /// Ambil metadata artikel (Feed) dari Firestore
  Future<void> fetchArticles() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('feeds').get();

      _articles = snapshot.docs
          .map((doc) => ArticleModel.fromMap(doc.id, doc.data()))
          .toList();

      // Acak urutan artikel untuk variasi
      _articles.shuffle();

      await fetchBookmarks();
    } catch (e) {
      debugPrint("Error fetching articles: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ambil ID artikel yang dibookmark user
  Future<void> fetchBookmarks() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .get();

      _bookmarkIds = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      debugPrint("Error fetching bookmarks: $e");
    }
  }

  /// Toggle Bookmark (Simpan ke Tonton Nanti)
  Future<void> toggleBookmark(ArticleModel article) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final isBookmarked = _bookmarkIds.contains(article.id);

    try {
      if (isBookmarked) {
        // Hapus bookmark
        _bookmarkIds.remove(article.id);
        notifyListeners();
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('bookmarks')
            .doc(article.id)
            .delete();
      } else {
        // Tambah bookmark
        _bookmarkIds.add(article.id);
        notifyListeners();
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('bookmarks')
            .doc(article.id)
            .set(article.toMap());
      }
    } catch (e) {
      // Rollback jika gagal
      if (isBookmarked) {
        _bookmarkIds.add(article.id);
      } else {
        _bookmarkIds.remove(article.id);
      }
      notifyListeners();
      rethrow;
    }
  }

  /// Cek apakah artikel sudah dibookmark
  bool isBookmarked(String articleId) {
    return _bookmarkIds.contains(articleId);
  }
}
