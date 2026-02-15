import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/feed_provider.dart';
import '../../models/article_model.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String _selectedTab = 'Semua';
  final List<String> _tabs = ['Semua', 'Tonton nanti'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<FeedProvider>().fetchArticles());
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch video')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<FeedProvider>().fetchArticles(),
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: false, // Hapus back button jika ada
                centerTitle: true,
                toolbarHeight: 100, // Meningkatkan tinggi agar tidak mepet
                title: const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text(
                    'Feed',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF1A1A1A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                sliver: Consumer<FeedProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final articles = _selectedTab == 'Semua'
                        ? provider.articles
                        : provider.articles
                            .where((a) => provider.isBookmarked(a.id))
                            .toList();

                    if (articles.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Text(
                            _selectedTab == 'Semua'
                                ? 'Belum ada konten'
                                : 'Belum ada video tersimpan',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final article = articles[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: _buildArticleCard(article, provider),
                          );
                        },
                        childCount: articles.length,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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

  Widget _buildArticleCard(ArticleModel article, FeedProvider provider) {
    final isSaved = provider.isBookmarked(article.id);

    return GestureDetector(
      onTap: () => _launchUrl(article.videoUrl),
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
                image: article.thumbnailUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(article.thumbnailUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: article.thumbnailUrl.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 60,
                        color: const Color(0xFF32D74B).withOpacity(0.5),
                      ),
                    )
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 16, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        article.duration,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => provider.toggleBookmark(article),
                        child: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_outline,
                          size: 24,
                          color: isSaved
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
