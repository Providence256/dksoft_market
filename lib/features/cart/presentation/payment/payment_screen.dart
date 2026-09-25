import 'dart:math';

import 'package:dksoft_market/common/custom_divider.dart';
import 'package:dksoft_market/common/empty_placeholder_widget.dart';
import 'package:dksoft_market/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market/features/cart/application/cart_service.dart';
import 'package:dksoft_market/features/cart/application/cart_summary.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/bill_row.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/delivery_mode_toggle.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/info_row.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/payment_bottom_bar.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/payment_cart_line_row.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/payment_header.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_widgets/section_card.dart';
import 'package:dksoft_market/features/dealer/data/dealer_repository.dart';
import 'package:dksoft_market/features/orders/data/fake_orders_repository.dart';
import 'package:dksoft_market/features/orders/data/firestore_orders_repository.dart';
import 'package:dksoft_market/features/orders/domain/order_model.dart';
import 'package:dksoft_market/features/products/data/products_repository.dart';
import 'package:dksoft_market/features/products/presentation/controller/selected_dealer_controller.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

const _orderIdChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

String _generateOrderId() {
  final random = Random();

  return List.generate(
    8,
    (_) => _orderIdChars[random.nextInt(_orderIdChars.length)],
  ).join();
}

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  DeliveryMode _mode = DeliveryMode.home;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartLinesProvider);
    final selectedDealerId = ref.watch(selectedDealerProvider);
    final dealer = selectedDealerId == null
        ? null
        : ref.watch(dealerByIdProvider(selectedDealerId));
    final subTotal = ref.watch(cartSubtotalProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            PaymentHeader(title: 'Commande'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(Sizes.p16),
                children: [
                  DeliveryModeToggle(
                    mode: _mode,
                    onChanged: (m) => setState(() => _mode = m),
                  ),
                  const SizedBox(height: Sizes.p16),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adresse du dealer',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: Sizes.p16),
                        InfoRow(
                          icon: HugeIcons.strokeRoundedLocation04,
                          title: 'Position actuelle',
                          subtitle: '${dealer?.address?.commune}',
                          onEdit: () => _showComingSoon(context, 'adresse'),
                        ),
                        const SizedBox(height: Sizes.p16),
                        InfoRow(
                          icon: HugeIcons.strokeRoundedUser,
                          title: '${dealer?.fullName}',
                          subtitle: '${dealer?.phone}',
                          onEdit: () => _showComingSoon(context, 'contact'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.p16),

                  SectionCard(
                    child: items.isEmpty
                        ? EmptyPlaceholderWidget(
                            title: 'title',
                            subTitle: 'subTitle',
                            icon: Icons.fork_left,
                          )
                        : Column(
                            children: [
                              for (var i = 0; i < items.length; i++) ...[
                                if (i > 0) const CustomDivider(),
                                Builder(
                                  builder: (_) {
                                    final item = items[i];
                                    final productValue = ref.watch(
                                      productStreamProvider(item.productId),
                                    );
                                    final product = productValue.value;

                                    if (product == null) {
                                      return SizedBox.shrink();
                                    }

                                    return PaymentCartLineRow(
                                      product: product,
                                      item: item,
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                  ),
                  const SizedBox(height: Sizes.p16),
                  Text(
                    'Récapitulatif de la facturation',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: Sizes.p12),
                  BillRow(label: "Prix de l'article", value: subTotal),
                  //BillRow(label: 'Remise', value: -10),
                  BillRow(label: 'Frais de livraison', valueText: 'Gratuit'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PaymentBottomBar(
        total: subTotal,
        onConfirm: (dealer == null || items.isEmpty || _isSubmitting)
            ? null
            : () => _confirmOrder(context, dealer.id, subTotal),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modification $label bientôt disponible.')),
    );
  }

  void _confirmOrder(
    BuildContext context,
    String dealerId,
    double total,
  ) async {
    final user = ref.watch(authRepositoryProvider).currentUser;

    if (user == null) return;

    setState(() => _isSubmitting = true);

    final items = ref.watch(cartLinesProvider);
    final orderItems = {
      for (final item in items)
        orderItemKey(item.productId, item.productId): item.quantity,
    };

    final order = OrderModel(
      id: _generateOrderId(),
      userId: user.uid,
      items: orderItems,
      orderStatus: OrderStatus.pending,
      orderDate: DateTime.now(),
      total: total,
      dealerId: dealerId,
    );

    await ref.read(ordersRepositoryProvider).addOrder(user.uid, order);
    // Notifie le dealer : écrit la commande dans Firestore, lu en temps
    // réel par l'app dealer (même projet Firebase).
    await ref.read(firestoreOrdersRepositoryProvider).addOrder(order);

    final cartService = ref.read(cartServiceProvider);
    for (final item in items) {
      await cartService.removeItem(item.productId, item.variationId);
    }

    ref.read(selectedDealerProvider.notifier).state = null;

    if (!context.mounted) return;
    setState(() => _isSubmitting = false);

    context.goNamed(AppRoute.orders.name);
  }
}
