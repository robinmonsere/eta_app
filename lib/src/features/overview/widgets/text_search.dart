import 'package:eta_app/src/ui/theme/border_radii.dart';
import 'package:eta_app/src/ui/theme/padding_sizes.dart';
import 'package:flutter/material.dart';

class TextSearch extends StatelessWidget {
  const TextSearch({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(
        PaddingSizes.small,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              controller.clear();
              onChanged('');
            },
            icon: const Icon(Icons.close),
          ),
          hintText: 'Search...',
          contentPadding: const EdgeInsets.symmetric(
            vertical: PaddingSizes.medium,
            horizontal: PaddingSizes.large,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              BorderRadii.xxl,
            ),
            borderSide: const BorderSide(
              color: Colors.blueAccent, // Slightly darker blue when focused
              width: 2,
            ),
          ),
          filled: true,
        ),
      ),
    );
  }
}
