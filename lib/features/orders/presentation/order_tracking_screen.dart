import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market/features/dealer/data/dealer_rating_repository.dart';
import 'package:dksoft_market/features/dealer/data/dealer_repository.dart';
import 'package:dksoft_market/features/orders/data/firestore_orders_repository.dart';
import 'package:dksoft_market/features/orders/domain/order_model.dart';
import 'package:dksoft_market/features/orders/presentation/widgets/rate_dealer_dialog.dart';
import 'package:dksoft_market/features/orders/presentation/widgets/status_chip.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OrderTrackingScreen extends ConsumerWidget {
  const OrderTrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderValue = ref.watch(orderProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Suivi commande',
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: AppColors.primary),
        ),
        centerTitle: false,
        elevation: 2,
        scrolledUnderElevation: 0.5,
      ),
      body: AsyncValueWidget(
        value: orderValue,
        data: (order) {
          if (order == null) {
            return const Center(child: Text('Commande introuvable.'));
          }
          return _OrderTracking(order: order);
        },
      ),
    );
  }
}

class _OrderTracking extends ConsumerWidget {
  const _OrderTracking({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd-MM-yyyy HH:mm');

    return ListView(
      padding: const EdgeInsets.all(Sizes.p20),
      children: [
        Text(
          '#${order.id}',
          style: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: Sizes.p4),
        Text(
          'Créée le ${dateFormat.format(order.orderDate)}',
          style: theme.textTheme.labelSmall!.copyWith(
            color: AppColors.textHintLight,
          ),
        ),
        const SizedBox(height: Sizes.p16),
        StatusChip(status: order.orderStatus),
        const SizedBox(height: Sizes.p16),
        Text(
          order.orderStatus.trackingDescription,
          style: theme.textTheme.labelMedium,
        ),
        const SizedBox(height: Sizes.p24),
        Text(
          'Historique',
          style: theme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: Sizes.p16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.orderStatus.label,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    dateFormat.format(order.orderDate),
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: AppColors.textHintLight,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_bottom_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        if (order.orderStatus == OrderStatus.pending) ...[
          const SizedBox(height: Sizes.p32),
          Text(
            'Actions disponibles',
            style: theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: Sizes.p16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _cancelOrder(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: Sizes.p12),
              ),
              child: const Text('Annuler la commande'),
            ),
          ),
        ] else if (order.orderStatus == OrderStatus.accepted ||
            order.orderStatus == OrderStatus.shipped) ...[
          const SizedBox(height: Sizes.p32),
          Text(
            'Actions disponibles',
            style: theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: Sizes.p16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _confirmDelivery(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: Sizes.p12),
              ),
              child: const Text('Livraison reçue'),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _cancelOrder(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Annuler cette commande ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Retour'),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.errorLight,
              foregroundColor: AppColors.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Annuler la commande'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    await ref
        .read(firestoreOrdersRepositoryProvider)
        .updateOrderStatus(user.uid, order.id, OrderStatus.cancelled);
  }

  Future<void> _confirmDelivery(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Confirmer la réception ?',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        content: Text(
          'Confirmez uniquement si vous avez bien reçu votre commande.',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('Retour', style: Theme.of(context).textTheme.bodySmall),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.success.withValues(alpha: 0.15),
              foregroundColor: AppColors.success,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Livraison reçue',
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: AppColors.success),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    await ref
        .read(firestoreOrdersRepositoryProvider)
        .updateOrderStatus(user.uid, order.id, OrderStatus.delivered);

    if (!context.mounted) return;
    await _maybePromptForRating(context, ref, userId: user.uid);
  }

  /// After a client's first completed order with a dealer, ask if they'd
  /// like to rate them. Never asks again once a rating exists for this
  /// dealer/client pair.
  Future<void> _maybePromptForRating(
    BuildContext context,
    WidgetRef ref, {
    required String userId,
  }) async {
    final ratingRepository = ref.read(dealerRatingRepositoryProvider);
    final alreadyRated = await ratingRepository.hasRated(
      order.dealerId,
      userId,
    );
    if (alreadyRated) return;

    final dealer = ref.read(dealerByIdProvider(order.dealerId));
    if (!context.mounted) return;

    final result = await showRateDealerDialog(
      context,
      dealerName: dealer?.fullName ?? 'ce dealer',
    );
    if (result == null) return;

    await ratingRepository.submitRating(
      dealerId: order.dealerId,
      userId: userId,
      rating: result.rating,
      comment: result.comment,
    );
  }
}
