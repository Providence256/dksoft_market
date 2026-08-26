import 'package:dksoft_market/helpers/attribute_color.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AttributeChoiceChip extends StatelessWidget {
  const AttributeChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: AttributeColor.getColor(text) != null
          ? const SizedBox()
          : Text(
              text,
              style: TextStyle(color: selected ? Colors.white : Colors.black),
            ),
      selected: selected,
      onSelected: onSelected,
      labelStyle: TextStyle(color: selected ? Colors.white : null),
      avatar: AttributeColor.getColor(text) != null
          ? Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AttributeColor.getColor(text),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            )
          : null,
      shape: AttributeColor.getColor(text) != null
          ? const CircleBorder()
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: AttributeColor.getColor(text) ?? Colors.grey.shade200,
      labelPadding: AttributeColor.getColor(text) != null
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: 4),
      padding: AttributeColor.getColor(text) != null
          ? EdgeInsets.zero
          : EdgeInsets.all(10),
      showCheckmark: AttributeColor.getColor(text) != null ? true : false,
      selectedColor: AttributeColor.getColor(text) != null
          ? Colors.transparent
          : AppColors.secondary,
    );
  }
}
