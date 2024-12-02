import 'dart:convert';

class Post {
  final String postId;
  final List<String>? techWords;
  final int? version;
  final bool? isTech;
  final bool? isHandled;
  final bool? isPosted;
  final DateTime? postedAt;
  final DateTime? techPostedAt;
  final String? type;
  final String? referenceId;
  final String? referenceName;
  final String? referenceAccountId;
  final DateTime? createdAt;
  final List<String>? mediaIds;
  final String? techId;

  Post({
    required this.postId,
    this.techWords,
    this.version,
    this.isTech,
    this.isHandled,
    this.isPosted,
    this.postedAt,
    this.techPostedAt,
    this.type = 'post',
    this.referenceId,
    this.referenceName,
    this.referenceAccountId,
    this.createdAt,
    this.mediaIds,
    this.techId,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['post_id'], // Required field
      techWords: map['tech_words'] != null
          ? List<String>.from(map['tech_words'])
          : null,
      version: map['version'],
      isTech: map['is_tech'],
      isHandled: map['is_handled'],
      isPosted: map['is_posted'],
      postedAt: map['posted_at'],
      techPostedAt: map['tech_posted_at'],
      type: map['type'],
      referenceId: map['reference_id'],
      referenceName: map['reference_name'],
      referenceAccountId: map['reference_account_id'],
      createdAt: map['created_at'],
      mediaIds: map['media_ids'],
      techId: map['tech_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId, // Required field
      'tech_words': techWords,
      'version': version,
      'is_tech': isTech,
      'is_handled': isHandled,
      'is_posted': isPosted,
      'posted_at': postedAt?.toIso8601String(),
      'tech_posted_at': techPostedAt?.toIso8601String(),
      'type': type,
      'reference_id': referenceId,
      'reference_name': referenceName,
      'reference_account_id': referenceAccountId,
      'created_at': createdAt?.toIso8601String(),
      'media_ids': mediaIds,
      'tech_id': techId,
    };
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));
}
