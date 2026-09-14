import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    super.key,
    required this.text,
    required this.subtitle,
    this.onTap,
  });

  final String text;
  final String subtitle;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: theme.textTheme.headlineSmall),
        InkWell(
          borderRadius: BorderRadius.circular(Sizes.p8),
          onTap: onTap ?? () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: theme.colorScheme.secondary,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                    decorationColor: theme.colorScheme.secondary,
                    decorationThickness: 2,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: theme.colorScheme.secondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
