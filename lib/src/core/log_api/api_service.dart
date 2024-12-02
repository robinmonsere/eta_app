import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CachedApiService {
  final String baseUrl = dotenv.env['LOG_API']!;
  final Map<String, dynamic> _cache = {};
  final Duration cacheDuration;

  CachedApiService({
    this.cacheDuration = const Duration(minutes: 5),
  });

  Future<List<String>> getLogFiles() async {
    const endpoint = '/logs/list';
    return _getCachedData(endpoint, _fetchLogFiles);
  }

  Future<String> getLogFile(String date, String type) async {
    final endpoint = '/logs/file?date=$date&type=$type';
    return _getCachedData(endpoint, () => _fetchLogFile(date, type));
  }

  Future<T> _getCachedData<T>(
      String key, Future<T> Function() fetchData) async {
    if (_cache.containsKey(key) &&
        DateTime.now().isBefore(_cache[key]['expiry'])) {
      return _cache[key]['data'];
    }

    final data = await fetchData();
    _cache[key] = {
      'data': data,
      'expiry': DateTime.now().add(cacheDuration),
    };
    return data;
  }

  Future<List<String>> _fetchLogFiles() async {
    final response = await http.get(Uri.parse('$baseUrl/logs/list'));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load log files');
    }
  }

  Future<String> _fetchLogFile(String date, String type) async {
    final response =
        await http.get(Uri.parse('$baseUrl/logs/file?date=$date&type=$type'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load log file');
    }
  }
}
