import 'package:eta_app/src/core/models/post.dart';
import 'package:flutter/material.dart';

class SmallPost extends StatelessWidget {
  const SmallPost({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    // Define a color for each post type
    Color postColor;
    switch (post.type) {
      case 'reply':
        postColor = Colors.purple;
        break;
      case 'quote':
        postColor = Colors.yellow;
        break;
      case 'repost':
        postColor = Colors.orange;
        break;
      default:
        postColor = Colors.blue; // Default color for 'blue' or other types
    }

    // Determine the appropriate icon and color based on post.is_tech
    Icon techIcon;
    Color iconColor;
    if (post.isTech ?? false) {
      techIcon = Icon(Icons.check);
      iconColor = Colors.green;
    } else {
      techIcon = Icon(Icons.close); // The "X" icon
      iconColor = Colors.red;
    }

    return ListTile(
      title: Text(post.postId),
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: post.isTech ?? false ? Colors.green : Colors.red, width: 3),
        borderRadius: BorderRadius.circular(5),
      ),
      trailing:
          Text(post.type ?? 'Unknown', style: TextStyle(color: postColor)),
    );
  }
}
