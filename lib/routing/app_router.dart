import 'package:dksoft_market/application_screen.dart';
import 'package:dksoft_market/features/authentication/data/fake_auth_repository.dart';
import 'package:dksoft_market/features/authentication/presentation/login_screen.dart';
import 'package:dksoft_market/features/authentication/presentation/signup_screen.dart';
import 'package:dksoft_market/features/booking/booking_screen.dart';
import 'package:dksoft_market/features/cart/presentation/shopping_cart/cart_screen.dart';
import 'package:dksoft_market/features/cart/presentation/shopping_cart/dealer_cart_screen.dart';
import 'package:dksoft_market/features/cart/presentation/checkout/checkout_screen.dart';
import 'package:dksoft_market/features/category/categories_screen.dart';
import 'package:dksoft_market/features/category/presentation/sub_categories_screen.dart';
import 'package:dksoft_market/features/category/presentation/sub_category_products_screen.dart';
import 'package:dksoft_market/features/wishlist/presentation/wishlist_screen.dart';
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
  favoris,
  categories,
  subCategories,
  subCategoryProducts,
  cart,
  dealerCart,
  checkout,
  bookings,
  profile,
  login,
  signup,
}

const _protectedPaths = ['/profile', '/bookings'];

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(fakeAuthRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final path = state.matchedLocation;
      final isAuthRoute = path == '/login' || path == 'signup';
      final isProtectedRoute = _protectedPaths.any(
        (route) => path.startsWith(route),
      );

      if (!isLoggedIn && isProtectedRoute) {
        return '/login';
      }

      if (isLoggedIn && isAuthRoute) {
        return '/profile';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.onboarding.name,
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: AppRoute.signup.name,
        builder: (context, state) => SignUpScreen(),
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

                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: '/categories',
                    name: AppRoute.categories.name,
                    builder: (context, state) => CategoriesScreen(),
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        path: ':categoryId',
                        name: AppRoute.subCategories.name,
                        builder: (context, state) {
                          final categoryId =
                              state.pathParameters['categoryId']!;
                          return SubCategoriesScreen(categoryId: categoryId);
                        },
                        routes: [
                          GoRoute(
                            parentNavigatorKey: _rootNavigatorKey,
                            path: ':subCategoryId',
                            name: AppRoute.subCategoryProducts.name,
                            builder: (context, state) {
                              final categoryId =
                                  state.pathParameters['categoryId']!;
                              final subCategoryId =
                                  state.pathParameters['subCategoryId']!;
                              return SubCategoryProductsScreen(
                                categoryId: categoryId,
                                subCategoryId: subCategoryId,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favoris',
                name: AppRoute.favoris.name,
                builder: (context, state) => WishListScreen(),
                routes: [],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                name: AppRoute.cart.name,
                builder: (context, state) => CartScreen(),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: '/dealer-cart/:id',
                    name: AppRoute.dealerCart.name,
                    pageBuilder: (context, state) {
                      final dealerId = state.pathParameters['id']!;
                      return MaterialPage(
                        fullscreenDialog: true,
                        child: DealerCartScreen(dealerId: dealerId),
                      );
                    },
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        path: 'checkout',
                        name: AppRoute.checkout.name,
                        builder: (context, state) {
                          final dealerId = state.pathParameters['id']!;
                          return CheckoutScreen(dealerId: dealerId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bookings',
                name: AppRoute.bookings.name,
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
