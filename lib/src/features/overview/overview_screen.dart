import 'package:eta_app/src/core/database/database_service.dart';
import 'package:eta_app/src/core/enums/filters.dart';
import 'package:eta_app/src/core/models/post.dart';
import 'package:eta_app/src/features/overview/widgets/post_filter.dart';
import 'package:eta_app/src/features/overview/widgets/small_post.dart';
import 'package:eta_app/src/features/overview/widgets/text_search.dart';
import 'package:eta_app/src/ui/theme/padding_sizes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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

  String _searchId = "";
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  PostFilterOption _currentFilter = PostFilterOption.all;
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

  /// Fetches a specific post and adds that post to the list of all posts
  /// This does mean that in theory, you could have the same post in the list.
  /// (fetch post by ID, and later fetch it by the paging system)
  /// But in reality, that doesn't matter.
  Future<void> _fetchPost(String id) async {
    setState(() {
      _isLoading = true;
    });
    await _dbService.connect();

    final posts = await _dbService.fetchPost(id);

    setState(() {
      if (posts.isNotEmpty) {
        _posts.addAll(posts);
      }
      _isLoading = false;
    });
    await _dbService.close();
    _filterPosts();
  }

  // Method to fetch posts from the database
  Future<void> _fetchPosts({
    int page = 1,
    int limit = 15,
  }) async {
    if (_isLoading || !_hasMore) {
      return;
      // no more data
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

  void _searchForSpecificPost() {
    if (_searchId.isNotEmpty) {
      _fetchPost(_searchId);
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

  void _filterPosts() {
    _searchId = "";
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
              _searchId = idToFilter;
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
          case PostFilterOption.replies:
            matchesFilter = post.type == 'reply';
            break;
          case PostFilterOption.quotes:
            matchesFilter = post.type == 'quote';
            break;
          case PostFilterOption.posts:
            matchesFilter = post.type == 'post';
            break;
          case PostFilterOption.reposts:
            matchesFilter = post.type == 'repost';
            break;
          case PostFilterOption.techPosted:
            matchesFilter = post.isTech == true && post.isPosted == true;
            break;
          case PostFilterOption.techNotPosted:
            matchesFilter = post.isTech == true && post.isPosted == false;
            break;
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
          PostFilter<PostFilterOption>(
            options: PostFilterOption.values,
            selectedOption: _currentFilter,
            onOptionSelected: (option) {
              _currentFilter = option;
              _filterPosts();
            },
          ),
          const SizedBox(
            height: PaddingSizes.small,
          ),
          TextSearch(
            controller: _searchController,
            onChanged: (_) => _filterPosts(),
          ),
          if (!_isLoading && _filteredPosts.isEmpty)
            OutlinedButton(
              onPressed: _searchId.isNotEmpty ? _searchForSpecificPost : null,
              child: Text("Search for post with ID: $_searchId"),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPosts,
              child: Material(
                child: ListView.builder(
                  padding: const EdgeInsets.all(
                    PaddingSizes.small,
                  ),
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
