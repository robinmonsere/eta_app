import 'package:eta_app/src/core/database/database_service.dart';
import 'package:eta_app/src/core/models/post.dart';
import 'package:eta_app/src/features/overview/widgets/post_filter.dart';
import 'package:eta_app/src/features/overview/widgets/small_post.dart';
import 'package:eta_app/src/features/overview/widgets/text_search.dart';
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
  List<Post> _filteredPosts = [];

  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String _currentFilter = "all";
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _scrollController.addListener(_scrollListener);
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
    _filterPosts();
  }

  // Listener for scrolling to the bottom
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
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

  Future<void> _fetchFilteredPosts(String filter) async {
    setState(() {
      _isLoading = true;
      _posts.clear();
      _filteredPosts.clear();
      _currentPage = 1;
      _hasMore = true;
    });

    await _dbService.connect();
    List<Post> posts;

    if (filter == "tech, posted") {
      posts = await _dbService.fetchTechPosts(
          posted: true, page: _currentPage, limit: 15);
    } else if (filter == "tech, not posted") {
      posts = await _dbService.fetchTechPosts(
          posted: false, page: _currentPage, limit: 15);
    } else {
      posts = await _dbService.fetchPosts(page: _currentPage, limit: 15);
    }

    setState(() {
      _isLoading = false;
      _posts.addAll(posts);
      _hasMore = posts.length == 15;
    });

    await _dbService.close();
    _filterPosts("", filterOption: filter);
  }

  void _filterPosts() {
    final query = _searchController.text;
    setState(() {
      if (query.isEmpty && _currentFilter == "all") {
        _filteredPosts = List.from(_posts);
        return;
      }

      _filteredPosts = _posts.where((post) {
        bool matchesQuery = false;
        if (query.isNotEmpty) {
          String idToFilter = query;
          if (query.startsWith('https://x.com/') ||
              query.startsWith('https://twitter.com/')) {
            final uri = Uri.parse(query);
            if (uri.pathSegments.length >= 3 &&
                uri.pathSegments[1] == 'status') {
              idToFilter = uri.pathSegments[2];
            }
          }
          matchesQuery =
              post.postId == idToFilter || post.referenceId == idToFilter;
        } else {
          // If query is empty, all posts match. Filter on type
          matchesQuery = true;
        }

        bool matchesFilter = true;
        switch (_currentFilter) {
          case "replies":
            matchesFilter = post.type == 'reply';
            break;
          case "quotes":
            matchesFilter = post.type == 'quote';
            break;
          case "posts":
            matchesFilter = post.type == 'post';
            break;
          case "reposts":
            matchesFilter = post.type == 'repost';
            break;
          // "tech, posted" and "tech, not posted" are handled separately
          default:
            matchesFilter = true;
        }
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PostFilter(
            options: const [
              "all",
              "tech, posted",
              "tech, not posted",
              "replies",
              "quotes",
              "posts",
              "reposts",
            ],
            selectedOption: _currentFilter,
            onOptionSelected: (option) {
              if (option == "tech, posted" || option == "tech, not posted") {
                //_fetchFilteredPosts(option);
              } else {
                _currentFilter = option;
                _filterPosts();
              }
            },
          ),
          const SizedBox(height: 10),
          TextSearch(
            controller: _searchController,
            onChanged: (_) => _filterPosts(),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPosts,
              child: Material(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  controller: _scrollController,
                  itemCount: _filteredPosts.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _filteredPosts.length && _isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final post = _filteredPosts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SmallPost(post: post),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
