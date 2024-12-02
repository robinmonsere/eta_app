import 'package:eta_app/src/core/enums/filters.dart';
import 'package:eta_app/src/ui/theme/border_radii.dart';
import 'package:eta_app/src/ui/theme/padding_sizes.dart';
import 'package:flutter/material.dart';

class PostFilter<T extends Enum> extends StatefulWidget {
  final List<T> options;
  final Function(T) onOptionSelected;
  final T? selectedOption;

  const PostFilter({
    super.key,
    required this.options,
    required this.onOptionSelected,
    this.selectedOption,
  });

  @override
  State<PostFilter<T>> createState() => _PostFilterState<T>();
}

class _PostFilterState<T extends Enum> extends State<PostFilter<T>> {
  T? _currentSelection;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.options.length,
        itemBuilder: (BuildContext context, int index) {
          final option = widget.options[index];
          final isSelected = _currentSelection == option;
          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.extraSmall,
            ),
            child: ChoiceChip(
              label: Text((option as dynamic).getDisplayText()),
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
                borderRadius: BorderRadius.circular(
                  BorderRadii.xxl,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingSizes.large,
                vertical: PaddingSizes.small,
              ),
            ),
          );
        },
      ),
    );
  }
}
