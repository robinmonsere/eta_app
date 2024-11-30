import 'package:postgres/postgres.dart';

class DatabaseService {
  late Connection _connection;

  Future<void> connect() async {
    _connection = await Connection.open(
      Endpoint(
        host: 'localhost', // Replace with your host
        database: 'postgres', // Replace with your database name
        username: 'user', // Replace with your username
        password: 'pass', // Replace with your password
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
    print('Connected to PostgreSQL');
  }

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final result = await _connection.execute(Sql('SELECT id FROM posts'));
    return result.map((row) => row.toColumnMap()).toList();
  }

  Future<void> close() async {
    await _connection.close();
    print('Connection closed');
  }
}
