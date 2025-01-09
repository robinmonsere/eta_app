import 'package:eta_app/src/core/database/database_service.dart';
import 'package:eta_app/src/core/models/post.dart';
import 'package:eta_app/src/core/routing/router.dart';
import 'package:eta_app/src/features/overview/overview_screen.dart';
import 'package:eta_app/src/ui/theme/padding_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailsScreen extends StatefulWidget {
  final Post post;

  static const String route = '/$location';
  static const String location = 'details';

  const DetailsScreen({super.key, required this.post});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late bool _isTech;
  bool _hasChanges = false;
  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    // Initialize the checkbox state with the post's isTech value
    _isTech = widget.post.isTech ?? false;
  }

  void _onTechChanged(bool? value) {
    if (value != null) {
      setState(() {
        _isTech = value;
        _hasChanges = _isTech != (widget.post.isTech ?? false);
      });
    }
  }

  Future<void> _saveChanges() async {
    await _dbService.connect();
    await _dbService.updatePost(
      postId: widget.post.postId.toString(),
      isTech: _isTech,
    );
    await _dbService.close();
    if (!mounted) return;
    context.go(OverviewScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.postId.toString()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(OverviewScreen.route); // Navigate back
          },
        ),
      ),
      body: Column(
        children: [
          Image.network(
            "https://x-post-image-generation.vercel.app/api/generate?id=${widget.post.postId}",
          ),
          const SizedBox(
            height: PaddingSizes.large,
          ),
          CheckboxListTile(
            title: const Text('Tech post'),
            value: _isTech,
            activeColor: Theme.of(context).colorScheme.secondary,
            onChanged: _onTechChanged,
          ),
          if (_isTech)
            Padding(
              padding: const EdgeInsets.all(
                PaddingSizes.small,
              ),
              child: Text("Tech words: ${widget.post.techWords}"),
            ),
          const SizedBox(
            height: PaddingSizes.large,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _hasChanges
                ? _saveChanges
                : null, // Button is enabled if there are changes
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
