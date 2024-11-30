import 'package:eta_app/src/features/overview/widgets/small_post.dart';
import 'package:flutter/material.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  static const String route = '/$location';
  static const String location = 'overview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Overview Screen'),
          Expanded(
            child: ListView(
              children: [
                SmallPost(postId: "1"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
