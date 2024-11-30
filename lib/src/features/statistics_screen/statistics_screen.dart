import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  static const String route = '/$location';
  static const String location = 'statistics';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Statistics Screen'),
      ),
    );
  }
}
