import 'package:flutter/material.dart';

const Color cardBackgroundColorLight = Color(0xFFF0F0F0);
const Color cardBorderColorLight = Color(0xFFD8D8D8);
const Color cardFocusBorderColorLight = Color.fromARGB(255, 203, 203, 203);
const onSurfaceColorLight = Color(0xFF7A7A7A); // Text

class CustomDropDownMenu extends StatelessWidget {
  final String hintText, title;
  final bool isRequired, isExpanded, isDense;
  final dynamic selectedValue;
  final double width;
  final List<DropdownMenuItem<dynamic>> dropdownMenuItems;
  final Function(dynamic) onSelected;
  const CustomDropDownMenu({
    super.key,
    this.isDense = true,
    this.isExpanded = false,
    required this.hintText,
    required this.title,
    required this.dropdownMenuItems,
    required this.onSelected,
    this.isRequired = false,
    this.selectedValue,
    this.width = 400,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 5,
          ),
          DropdownButtonFormField(
            isExpanded: isExpanded,
            isDense: isDense,
            value: selectedValue,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (isRequired && value == null) {
                return 'This field is required';
              } else {
                return null;
              }
            },
            hint: Text(
              hintText,
            ),
            items: dropdownMenuItems,
            onChanged: onSelected,
          ),
          // DropdownMenu(
          //   onSelected: onSelected,
          //   hintText: hintText,
          //   menuStyle: const MenuStyle(
          //     padding: MaterialStatePropertyAll(
          //         EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
          //     backgroundColor: MaterialStatePropertyAll(
          //       backgroundColorLight,
          //     ),
          //   ),
          //   width: 400,
          //   dropdownMenuEntries: dropdownMenuEntries,
          // ),
        ],
      ),
    );
  }
}

class CustomSearchDropDownMenu extends StatefulWidget {
  final String hintText, title;
  final bool isRequired, isExpanded, isDense;
  final dynamic selectedValue;
  final IconData iconData;
  final List<DropdownMenuItem<dynamic>> dropdownMenuItems;
  final Function(dynamic) onSelected;
  final double width;

  const CustomSearchDropDownMenu({
    super.key,
    this.isDense = false,
    this.isExpanded = false,
    required this.hintText,
    required this.title,
    required this.dropdownMenuItems,
    required this.onSelected,
    this.isRequired = false,
    this.selectedValue,
    required this.iconData,
    this.width = 400,
  });

  @override
  State<CustomSearchDropDownMenu> createState() => _CustomSearchDropDownMenuState();
}

class _CustomSearchDropDownMenuState extends State<CustomSearchDropDownMenu> {
  dynamic currentValue;
  String? displayText;

  @override
  void initState() {
    super.initState();
    currentValue = widget.selectedValue;
    _updateDisplayText();
  }

  @override
  void didUpdateWidget(CustomSearchDropDownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue) {
      currentValue = widget.selectedValue;
      _updateDisplayText();
    }
  }

  void _updateDisplayText() {
    if (currentValue == null) {
      displayText = null;
      return;
    }

    for (var item in widget.dropdownMenuItems) {
      if (item.value == currentValue) {
        if (item.child is Text) {
          displayText = (item.child as Text).data;
        } else {
          displayText = currentValue.toString();
        }
        return;
      }
    }

    // If we got here, we couldn't find a matching item
    displayText = currentValue.toString();
  }

  // // Method to extract label from a dropdown item
  // String _getItemLabel(DropdownMenuItem item) {
  //   if (item.child is Text) {
  //     return (item.child as Text).data ?? item.value?.toString() ?? '';
  //   }
  //   return item.value?.toString() ?? '';
  // }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: widget.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 5),
          FormField<dynamic>(
            initialValue: currentValue,
            validator: (value) {
              if (widget.isRequired && value == null) {
                return 'This field is required';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AdaptiveSearchDropdown(
                    items: widget.dropdownMenuItems,
                    selectedValue: currentValue,
                    hintText: widget.hintText,
                    iconData: widget.iconData,
                    isDense: widget.isDense,
                    width: widget.width,
                    onSelected: (value) {
                      setState(() {
                        currentValue = value;
                        _updateDisplayText();
                      });
                      widget.onSelected(value);
                      formState.didChange(value);
                    },
                  ),
                  if (formState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 12),
                      child: Text(
                        formState.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Separate widget for the adaptive dropdown
class _AdaptiveSearchDropdown extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final dynamic selectedValue;
  final String hintText;
  final IconData iconData;
  final bool isDense;
  final Function(dynamic) onSelected;
  final double width;

  const _AdaptiveSearchDropdown({
    required this.items,
    required this.selectedValue,
    required this.hintText,
    required this.iconData,
    required this.isDense,
    required this.onSelected,
    this.width = 400,
  });

  // Helper method to get label from item
  String _getItemLabel(DropdownMenuItem item) {
    if (item.child is Text) {
      return (item.child as Text).data ?? item.value?.toString() ?? '';
    }
    return item.value?.toString() ?? '';
  }

  String? get displayText {
    if (selectedValue == null) return null;

    for (var item in items) {
      if (item.value == selectedValue) {
        return _getItemLabel(item);
      }
    }
    return selectedValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackgroundColorLight,
        border: Border.all(color: cardBorderColorLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SearchAnchor(
        viewShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: cardBorderColorLight,
          ),
        ),
        builder: (context, controller) {
          return InkWell(
            onTap: () {
              controller.openView();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: isDense ? 8 : 10,
              ),
              child: Row(children: [
                Icon(
                  iconData,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    displayText ?? hintText,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: displayText == null ? onSurfaceColorLight : null,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ]),
            ),
          );
        },
        viewBuilder: (suggestions) {
          return SizedBox(
            width: width, // Match parent width

            child: suggestions.isEmpty
                ? const Center(child: Text("No results found"))
                : ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: suggestions.toList(), // Convert Iterable to List
                  ),
          );
        },
        suggestionsBuilder: (context, controller) {
          final keyword = controller.text.toLowerCase();

          // Filter items based on search text
          final filteredItems = keyword.isEmpty
              ? items
              : items.where((item) {
                  final label = _getItemLabel(item).toLowerCase();
                  return label.contains(keyword);
                }).toList();

          return filteredItems.map((item) {
            final label = _getItemLabel(item);
            return ListTile(
              title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
              selectedTileColor: cardBorderColorLight,
              selected: item.value == selectedValue,
              onTap: () {
                onSelected(item.value);
                controller.closeView(label);
              },
            );
          }).toList();
        },
      ),
    );
  }
}
