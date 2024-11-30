import 'package:eta_app/src/core/database/database_service.dart';
import 'package:eta_app/src/core/models/post.dart';
import 'package:eta_app/src/features/overview/widgets/small_post.dart';
import 'package:flutter/material.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  static const String route = '/$location';
  static const String location = 'overview';

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<Post> _posts = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _scrollController.addListener(_scrollListener); // Listen to scroll events
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Don't forget to dispose the controller
    super.dispose();
  }

  // Method to fetch posts from the database
  Future<void> _fetchPosts({
    int page = 1,
    int limit = 15,
  }) async {
    print('Fetching posts from page $page');
    if (_isLoading || !_hasMore) {
      return; // Prevent multiple fetches or fetch when there's no more data
    }
    setState(() {
      _isLoading = true;
    });

    await _dbService.connect();
    final posts = await _dbService.fetchPosts(page: page, limit: limit);

    setState(() {
      _isLoading = false;
      if (posts.isNotEmpty) {
        _currentPage = page;
        _posts.addAll(posts);
        _hasMore = posts.length == limit;
      }
    });

    await _dbService.close();
  }

  // Listener for scrolling to the bottom
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Trigger next page fetch when scrolled to the bottom
      _fetchPosts(page: _currentPage + 1);
    }
  }

  // Refresh method for pull-to-refresh
  Future<void> _refreshPosts() async {
    setState(() {
      _posts.clear();
      _hasMore = true;
      _currentPage = 1;
    });
    await _fetchPosts(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Overview Screen'),
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPosts,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                controller: _scrollController,
                itemCount: _posts.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _posts.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final post = _posts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SmallPost(post: post),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
