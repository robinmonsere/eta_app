import 'package:eta_app/src/core/models/post.dart';
import 'package:eta_app/src/features/details/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SmallPost extends StatelessWidget {
  const SmallPost({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.go(
          DetailsScreen.route,
          extra: post,
        );
      },
      title: Text(post.postId),
      tileColor: Theme.of(context).colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: post.isTech ?? false ? Colors.green : Colors.red, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      trailing: Text(post.type ?? 'Unknown'),
    );
  }
}
