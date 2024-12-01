import 'package:flutter/material.dart';

class PostFilter extends StatefulWidget {
  final List<String> options;
  final Function(String) onOptionSelected;
  final String? selectedOption;

  const PostFilter({
    super.key,
    required this.options,
    required this.onOptionSelected,
    this.selectedOption,
  });

  @override
  State<PostFilter> createState() => _PostFilterState();
}

class _PostFilterState extends State<PostFilter> {
  String? _currentSelection;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 50.0, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.options.length,
        itemBuilder: (BuildContext context, int index) {
          final option = widget.options[index];
          final isSelected = _currentSelection == option;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _currentSelection = option;
                    widget.onOptionSelected(option);
                  }
                });
              },
              labelStyle: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 14,
              ),
              selectedColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
          );
        },
      ),
    );
  }
}
