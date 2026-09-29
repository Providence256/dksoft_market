import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class RateDealerResult {
  const RateDealerResult({required this.rating, required this.comment});

  final int rating;
  final String comment;
}

/// Asks the client if they'd like to rate the dealer, with an easy way
/// to skip. Returns null if they close/skip, otherwise the chosen rating.
Future<RateDealerResult?> showRateDealerDialog(
  BuildContext context, {
  required String dealerName,
}) {
  return showDialog<RateDealerResult>(
    context: context,
    builder: (context) => _RateDealerDialog(dealerName: dealerName),
  );
}

class _RateDealerDialog extends StatefulWidget {
  const _RateDealerDialog({required this.dealerName});

  final String dealerName;

  @override
  State<_RateDealerDialog> createState() => _RateDealerDialogState();
}

class _RateDealerDialogState extends State<_RateDealerDialog> {
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Comment s\'est passée votre commande ?',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Donnez une note à ${widget.dealerName}',
            style: theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: Sizes.p12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = index + 1;
              return IconButton(
                onPressed: () => setState(() => _rating = starValue),
                icon: Icon(
                  starValue <= _rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: Colors.amber,
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: Sizes.p8),
          TextField(
            controller: _commentController,
            maxLines: 3,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
            decoration: InputDecoration(
              hintText: 'Un commentaire (facultatif)',
              hintStyle: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(color: AppColors.textHintLight),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Plus tard',
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: AppColors.primary),
          ),
        ),
        FilledButton(
          onPressed: _rating == 0
              ? null
              : () => Navigator.of(context).pop(
                  RateDealerResult(
                    rating: _rating,
                    comment: _commentController.text.trim(),
                  ),
                ),
          style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
          child: Text(
            'Envoyer',
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: AppColors.warningLight),
          ),
        ),
      ],
    );
  }
}
