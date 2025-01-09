import 'package:eta_app/src/core/database/database_service.dart';
import 'package:eta_app/src/core/enums/filters.dart';
import 'package:eta_app/src/features/overview/widgets/post_filter.dart';
import 'package:eta_app/src/features/statistics_screen/widgets/info_block.dart';
import 'package:eta_app/src/ui/theme/padding_sizes.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  static const String route = '/$location';
  static const String location = 'statistics';

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final DatabaseService _dbService = DatabaseService();
  StatisticsFilter _currentFilter = StatisticsFilter.all;
  String _total = "...";
  String _tech = "...";

  @override
  void initState() {
    super.initState();
    _fetchTotal();
    _fetchTech();
  }

  Future<void> _fetchTotal() async {
    await _dbService.connect();
    int res = await _dbService.getPostCount(_currentFilter);
    setState(() {
      _total = res.toString();
    });

    await _dbService.close();
  }

  Future<void> _fetchTech() async {
    await _dbService.connect();
    int res = await _dbService.getPostCount(
      _currentFilter,
      isTech: true,
    );
    setState(() {
      _tech = res.toString();
    });

    await _dbService.close();
  }

  void _refresh() {
    _fetchTotal();
    _fetchTech();
  }

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
              _refresh();
            },
          ),
          const SizedBox(
            height: PaddingSizes.extraSmall,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingSizes.small,
              ),
              child: Text(
                "Data collection started November 5th, 2024",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: PaddingSizes.extraSmall,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.small,
            ),
            child: Row(
              children: [
                InfoBlock(
                  title: "Total Posts",
                  value: _total,
                ),
                const SizedBox(
                  width: PaddingSizes.medium,
                ),
                InfoBlock(
                  title: "Tech posts",
                  value: _tech,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: PaddingSizes.extraLarge,
          ),
          Text(
            "More statistics coming soon!",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
