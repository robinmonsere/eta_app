import 'package:flutter/material.dart';

class SmallPost extends StatelessWidget {
  const SmallPost({
    super.key,
    required this.postId,
  });

  final String postId;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(postId),
    );
  }
}
