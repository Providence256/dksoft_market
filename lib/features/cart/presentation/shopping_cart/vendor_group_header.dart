import 'package:dksoft_market/features/cart/application/cart_summary.dart';
import 'package:flutter/material.dart';

class VendorGroupHeader extends StatelessWidget {
  const VendorGroupHeader({super.key, required this.group});

  final VendorCartGroup group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final merchant = group.merchant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: theme.colorScheme.primaryContainer,
            backgroundImage: merchant.avatarUrl != null
                ? NetworkImage(merchant.avatarUrl!)
                : null,
            child: merchant.avatarUrl == null
                ? Text(
                    merchant.name.isNotEmpty
                        ? merchant.name[0].toUpperCase()
                        : '?',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    merchant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (merchant.verified) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.verified,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              group.totalQuantity > 1
                  ? '${group.totalQuantity} articles'
                  : '${group.totalQuantity} article',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
