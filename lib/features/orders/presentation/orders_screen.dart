import 'package:dksoft_market/common/async_value_widget.dart';
import 'package:dksoft_market/common/empty_placeholder_widget.dart';
import 'package:dksoft_market/features/dealer/data/dealer_repository.dart';
import 'package:dksoft_market/features/orders/data/firestore_orders_repository.dart';
import 'package:dksoft_market/features/orders/domain/order_model.dart';
import 'package:dksoft_market/features/orders/presentation/widgets/status_chip.dart';
import 'package:dksoft_market/features/products/data/products_repository.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:dksoft_market/utils/formatters/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

enum _OrdersFilter { all, ongoing, done }

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  _OrdersFilter _filter = _OrdersFilter.all;

  @override
  Widget build(BuildContext context) {
    final ordersValue = ref.watch(userOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Commandes',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall!.copyWith(color: AppColors.primary),
        ),
        centerTitle: false,
        elevation: 2,
        scrolledUnderElevation: 0.5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Sizes.p20,
              Sizes.p12,
              Sizes.p20,
              Sizes.p12,
            ),
            child: Row(
              children: [
                _FilterTab(
                  label: 'Tous',
                  selected: _filter == _OrdersFilter.all,
                  onTap: () => setState(() => _filter = _OrdersFilter.all),
                ),
                const SizedBox(width: Sizes.p8),
                _FilterTab(
                  label: 'En cours',
                  selected: _filter == _OrdersFilter.ongoing,
                  onTap: () => setState(() => _filter = _OrdersFilter.ongoing),
                ),
                const SizedBox(width: Sizes.p8),
                _FilterTab(
                  label: 'Terminés',
                  selected: _filter == _OrdersFilter.done,
                  onTap: () => setState(() => _filter = _OrdersFilter.done),
                ),
              ],
            ),
          ),
          Expanded(
            child: AsyncValueWidget(
              value: ordersValue,
              data: (orders) {
                final filtered = orders.where((order) {
                  switch (_filter) {
                    case _OrdersFilter.all:
                      return true;
                    case _OrdersFilter.ongoing:
                      return order.orderStatus.isOngoing;
                    case _OrdersFilter.done:
                      return !order.orderStatus.isOngoing;
                  }
                }).toList();

                if (filtered.isEmpty) {
                  return const EmptyPlaceholderWidget(
                    title: 'Aucune Commande',
                    subTitle: 'Vos commandes apparaîtront ici.',
                    icon: Icons.shopping_cart,
                  );
                }

                return ListView(
                  children: [
                    for (final order in filtered)
                      _OrderTile(key: ValueKey(order.id), order: order),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(Sizes.p12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Sizes.p10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? Colors.white : AppColors.textSecondaryLight,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderTile extends ConsumerWidget {
  const _OrderTile({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dealer = ref.watch(dealerByIdProvider(order.dealerId));
    final lines = order.toOrderItems();
    final firstLine = lines.isNotEmpty ? lines.first : null;
    final productAsync = firstLine != null
        ? ref.watch(productStreamProvider(firstLine.productId))
        : null;

    final firstProduct = productAsync!.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: AppColors.cardLight,
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p20,
            vertical: Sizes.p10,
          ),
          child: Text(
            dealer?.fullName ?? 'Dealer',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        InkWell(
          onTap: () => context.goNamed(
            AppRoute.orderDetails.name,
            pathParameters: {'orderId': order.id},
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p20,
              vertical: Sizes.p12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    firstProduct?.images.isNotEmpty == true
                        ? firstProduct!.images.first
                        : '',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 56,
                      height: 56,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: Sizes.p12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('#${order.id}', style: theme.textTheme.bodyMedium),
                      const SizedBox(height: Sizes.p4),
                      Text(
                        '${order.itemsCount} article(s) - '
                        '${CurrencyFormatter.format(order.total)}',
                        style: theme.textTheme.labelMedium!.copyWith(
                          color: AppColors.textHintLight,
                        ),
                      ),
                      const SizedBox(height: Sizes.p8),
                      Row(
                        children: [
                          StatusChip(status: order.orderStatus),
                          const SizedBox(width: Sizes.p8),
                          Text(
                            DateFormat(
                              'dd-MM-yyyy HH:mm',
                            ).format(order.orderDate),
                            style: theme.textTheme.labelSmall!.copyWith(
                              color: AppColors.textHintLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHintLight,
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: AppColors.dividerLight),
      ],
    );
  }
}
