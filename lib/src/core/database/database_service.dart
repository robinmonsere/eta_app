import 'package:eta_app/src/core/enums/filters.dart';
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

  Future<int> getPostCount(StatisticsFilter filter, {bool? isTech}) async {
    String timeCondition;
    switch (filter) {
      case StatisticsFilter.today:
        timeCondition = "created_at >= NOW() - INTERVAL '1 day'";
        break;
      case StatisticsFilter.sevenDays:
        timeCondition = "created_at >= NOW() - INTERVAL '7 days'";
        break;
      case StatisticsFilter.twoWeeks:
        timeCondition = "created_at >= NOW() - INTERVAL '14 days'";
        break;
      case StatisticsFilter.oneMonth:
        timeCondition = "created_at >= NOW() - INTERVAL '1 month'";
        break;
      case StatisticsFilter.all:
      default:
        timeCondition = "";
    }
    String techCondition =
        isTech != null ? "is_tech = ${isTech ? 'TRUE' : 'FALSE'}" : "";
    String condition = [timeCondition, techCondition]
        .where((c) => c.isNotEmpty) // Exclude empty conditions
        .join(" AND ");
    condition = condition.isNotEmpty ? "WHERE $condition" : "";

    final query = 'SELECT COUNT(*) FROM posts $condition';
    final result = await _connection.execute(Sql(query));

    return (result[0][0] as int);
  }

  Future<List<Post>> fetchPost(String id) async {
    final result = await _connection.execute(
        Sql.named('SELECT * from posts WHERE post_id = @post_id'),
        parameters: {
          'post_id': id,
        });
    return result.map((row) {
      return Post.fromMap(row.toColumnMap());
    }).toList();
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
