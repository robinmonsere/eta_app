import 'package:eta_app/src/core/log_api/api_service.dart';
import 'package:eta_app/src/features/logs/log_screen.dart';
import 'package:flutter/material.dart';

class LogDetailScreen extends StatefulWidget {
  final String logFileName;

  const LogDetailScreen({super.key, required this.logFileName});

  static const String route = '${LogScreen.route}$location';
  static const String location = '/detail';

  @override
  State<LogDetailScreen> createState() => _LogDetailScreenState();
}

class _LogDetailScreenState extends State<LogDetailScreen> {
  final CachedApiService _apiService = CachedApiService();
  String? _logContent;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLogContent();
  }

  Future<void> _fetchLogContent() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final parts = widget.logFileName.split('_');
      final date = parts.last.split('.').first;
      final type = parts.first == 'post' ? 'post' : 'fetch';

      final content = await _apiService.getLogFile(date, type);
      setState(() {
        _logContent = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error fetching log content: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.logFileName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_logContent ?? ''),
                  ),
                ),
    );
  }
}
