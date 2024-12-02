import 'package:eta_app/src/core/log_api/api_service.dart';
import 'package:eta_app/src/features/logs/log_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  static const String route = '/$location';
  static const String location = 'logs';

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final CachedApiService _apiService = CachedApiService();
  List<String> _logFiles = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLogFiles();
  }

  Future<void> _fetchLogFiles() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final files = await _apiService.getLogFiles();
      files.sort((a, b) {
        final dateA = _extractDate(a);
        final dateB = _extractDate(b);
        return dateB.compareTo(dateA);
      });
      setState(() {
        _logFiles = files;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error fetching log files: $e';
        _isLoading = false;
      });
    }
  }

  DateTime _extractDate(String filename) {
    final parts = filename.split('_');
    final dateString = parts.last.split('.').first;
    return DateTime.parse(dateString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Files'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  onRefresh: _fetchLogFiles,
                  child: ListView.builder(
                    itemCount: _logFiles.length,
                    itemBuilder: (context, index) {
                      final logFile = _logFiles[index];
                      final isPostProcessing =
                          logFile.startsWith('post_processing');
                      final icon = isPostProcessing
                          ? Icons.post_add
                          : Icons.cloud_download;
                      return ListTile(
                        leading: Icon(icon),
                        title: Text(logFile),
                        onTap: () {
                          context.go(
                            LogDetailScreen.route,
                            extra: logFile,
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
