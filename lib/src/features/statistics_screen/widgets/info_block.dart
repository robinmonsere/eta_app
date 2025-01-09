import 'package:eta_app/src/ui/theme/border_radii.dart';
import 'package:eta_app/src/ui/theme/padding_sizes.dart';
import 'package:flutter/material.dart';

class InfoBlock extends StatelessWidget {
  final String title;
  final String value;

  const InfoBlock({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(
          vertical: PaddingSizes.small,
          horizontal: PaddingSizes.large,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(
            BorderRadii.small,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
