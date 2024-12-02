import 'package:eta_app/src/core/enums/filters.dart';
import 'package:eta_app/src/features/overview/widgets/post_filter.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  static const String route = '/$location';
  static const String location = 'statistics';

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  StatisticsFilter _currentFilter = StatisticsFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PostFilter<StatisticsFilter>(
            options: StatisticsFilter.values,
            selectedOption: _currentFilter,
            onOptionSelected: (option) {
              _currentFilter = option;
              //_filterPosts();
            },
          ),
        ],
      ),
    );
  }
}
