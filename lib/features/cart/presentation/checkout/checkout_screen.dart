import 'package:dksoft_market/features/authentication/data/fake_auth_repository.dart';
import 'package:dksoft_market/features/authentication/presentation/login_screen.dart';
import 'package:dksoft_market/features/cart/presentation/payment/payment_screen.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CheckoutSubRoute { register, payment }

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late final PageController _controller;
  var _subRoute = CheckoutSubRoute.register;

  @override
  void initState() {
    super.initState();
    final user = ref.read(fakeAuthRepositoryProvider).currentUser;
    if (user != null) {
      setState(() => _subRoute = CheckoutSubRoute.payment);
    }

    _controller = PageController(initialPage: _subRoute.index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(fakeAuthStateChangeProvider, (previous, next) {
      final isLoggedIn = next.value != null;
      if (isLoggedIn && _subRoute == CheckoutSubRoute.register) {
        setState(() => _subRoute = CheckoutSubRoute.payment);

        _controller.animateToPage(
          CheckoutSubRoute.payment.index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          LoginScreen(onSuccess: () {}),
          PaymentScreen(),
        ],
      ),
    );
  }
}
