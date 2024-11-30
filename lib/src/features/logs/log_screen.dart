import 'package:flutter/material.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  static const String route = '/$location';
  static const String location = 'logs';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Log Screen"),
    );
  }
}
