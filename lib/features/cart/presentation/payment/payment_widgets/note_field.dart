import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class NoteField extends StatelessWidget {
  const NoteField({super.key, required this.note, required this.onTap});

  final String? note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Sizes.p12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p12,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.dividerLight),
          borderRadius: BorderRadius.circular(Sizes.p12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                note?.isNotEmpty == true
                    ? note!
                    : 'Sélectionnez votre instruction',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: note?.isNotEmpty == true
                      ? AppColors.textPrimaryLight
                      : AppColors.textHintLight,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHintLight,
            ),
          ],
        ),
      ),
    );
  }
}
