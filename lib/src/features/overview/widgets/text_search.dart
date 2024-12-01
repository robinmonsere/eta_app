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
      margin: const EdgeInsets.all(8.0),
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
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
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
