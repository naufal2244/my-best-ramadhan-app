import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String _selectedTab = 'Semua';

  final List<String> _tabs = ['Semua', 'Tonton nanti'];

  // Sample articles data
  final List<Map<String, dynamic>> _articles = [
    {
      'id': 1,
      'title': 'Jadikan Ramadhan Terbaikmu',
      'subtitle': 'Tips untuk memaksimalkan ibadah di bulan suci',
      'image':
          'https://via.placeholder.com/400x200/32D74B/FFFFFF?text=Ramadhan',
      'category': 'Ibadah',
      'readTime': '5 menit',
      'date': '12 Ramadhan 1446',
      'isSaved': false,
    },
    {
      'id': 2,
      'title': 'Keutamaan Membaca Al-Qur\'an',
      'subtitle': 'Pahala berlipat di bulan Ramadhan',
      'image':
          'https://via.placeholder.com/400x200/63E677/FFFFFF?text=Al-Quran',
      'category': 'Al-Qur\'an',
      'readTime': '4 menit',
      'date': '11 Ramadhan 1446',
      'isSaved': false,
    },
    {
      'id': 3,
      'title': 'Doa-doa di Bulan Ramadhan',
      'subtitle': 'Kumpulan doa yang mustajab',
      'image': 'https://via.placeholder.com/400x200/FFA726/FFFFFF?text=Doa',
      'category': 'Doa',
      'readTime': '3 menit',
      'date': '10 Ramadhan 1446',
      'isSaved': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredArticles {
    if (_selectedTab == 'Semua') {
      return _articles;
    } else {
      return _articles.where((article) => article['isSaved'] == true).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feed',
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xFF1A1A1A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tabs
                      Row(
                        children: _tabs.map((tab) => _buildTab(tab)).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // Articles List
            SliverPadding(
              padding: const EdgeInsets.all(24.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final article = _filteredArticles[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: _buildArticleCard(article),
                    );
                  },
                  childCount: _filteredArticles.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String tab) {
    final isSelected = _selectedTab == tab;

    return GestureDetector(
      onTap: () => setState(() => _selectedTab = tab),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF32D74B) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tab,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article) {
    return GestureDetector(
      onTap: () {
        // Navigate to article detail
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF5F5F5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F9EC),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF32D74B).withOpacity(0.8),
                    const Color(0xFF63E677).withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.auto_stories_outlined,
                      size: 60,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  // Category badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        article['category'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF32D74B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 16, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        article['readTime'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            article['isSaved'] = !article['isSaved'];
                          });
                        },
                        child: Icon(
                          article['isSaved']
                              ? Icons.bookmark
                              : Icons.bookmark_outline,
                          size: 24,
                          color: article['isSaved']
                              ? const Color(0xFF32D74B)
                              : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
