import 'package:eta_app/src/core/models/post.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';

class DatabaseService {
  late Connection _connection;

  Future<void> connect() async {
    _connection = await Connection.open(
      Endpoint(
        host: dotenv.env['POSTGRES_HOST']!,
        database: dotenv.env['POSTGRES_DB']!,
        username: dotenv.env['POSTGRES_USER']!,
        password: dotenv.env['POSTGRES_PASSWORD']!,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.require),
    );
    print('Connected to PostgreSQL');
  }

  Future<void> updatePost({
    required String postId,
    required bool isTech,
  }) async {
    print('Updating post $postId with isTech=$isTech');
    await _connection.execute(
      Sql.named(
        'UPDATE posts SET is_tech = @isTech WHERE post_id = @postId',
      ),
      parameters: {
        'postId': postId,
        'isTech': isTech,
      },
    );
  }

  Future<List<Post>> fetchPosts({
    int page = 1,
    int limit = 10,
  }) async {
    final offset = (page - 1) * limit;
    final result = await _connection.execute(
      Sql.named(
          'SELECT * FROM posts ORDER BY created_at DESC LIMIT @limit OFFSET @offset'),
      parameters: {
        'limit': limit,
        'offset': offset,
      },
    );
    return result.map((row) {
      return Post.fromMap(row.toColumnMap());
    }).toList();
  }

  Future<List<Post>> fetchTechPosts({
    required bool posted,
    required int page,
    required int limit,
  }) async {
    final offset = (page - 1) * limit;
    final result = await _connection.execute(
      Sql.named(
          'SELECT * FROM posts WHERE is_tech = true AND is_posted = @posted ORDER BY created_at DESC LIMIT @limit OFFSET @offset'),
      parameters: {
        'posted': posted,
        'limit': limit,
        'offset': offset,
      },
    );
    return result.map((row) {
      return Post.fromMap(row.toColumnMap());
    }).toList();
  }

  Future<void> close() async {
    await _connection.close();
    print('Connection closed');
  }
}
