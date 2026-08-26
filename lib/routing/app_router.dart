import 'package:dksoft_market/application_screen.dart';
import 'package:dksoft_market/features/booking/booking_screen.dart';
import 'package:dksoft_market/features/cart/presentation/shopping_cart/cart_screen.dart';
import 'package:dksoft_market/features/category/categories_screen.dart';
import 'package:dksoft_market/features/home/home_screen.dart';
import 'package:dksoft_market/features/onboarding/onboarding_screen.dart';
import 'package:dksoft_market/features/products/presentation/product_screen.dart';
import 'package:dksoft_market/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  onboarding,
  application,
  home,
  product,
  categories,
  cart,
  booking,
  profile,
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.onboarding.name,
        builder: (context, state) => OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ApplicationScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: AppRoute.home.name,
                builder: (context, state) => HomeScreen(),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: '/product/:id',
                    name: AppRoute.product.name,
                    builder: (context, state) {
                      final productId = state.pathParameters['id']!;
                      return ProductScreen(productId: productId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                name: AppRoute.categories.name,
                builder: (context, state) => CategoriesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                name: AppRoute.cart.name,
                builder: (context, state) => CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bookings',
                name: AppRoute.booking.name,
                builder: (context, state) => BookingScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: AppRoute.profile.name,
                builder: (context, state) => ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
