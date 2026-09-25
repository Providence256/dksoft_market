import 'package:dksoft_market/application_screen.dart';
import 'package:dksoft_market/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market/features/authentication/presentation/login_screen.dart';
import 'package:dksoft_market/features/authentication/presentation/signup_screen.dart';
import 'package:dksoft_market/features/cart/presentation/shopping_cart/cart_screen.dart';
import 'package:dksoft_market/features/cart/presentation/checkout/checkout_screen.dart';
import 'package:dksoft_market/features/category/categories_screen.dart';
import 'package:dksoft_market/features/category/presentation/sub_categories_screen.dart';
import 'package:dksoft_market/features/category/presentation/sub_category_products_screen.dart';
import 'package:dksoft_market/features/orders/presentation/order_details_screen.dart';
import 'package:dksoft_market/features/orders/presentation/order_tracking_screen.dart';
import 'package:dksoft_market/features/orders/presentation/orders_screen.dart';
import 'package:dksoft_market/features/products/presentation/widgets/dealer_picker_sheet.dart';
import 'package:dksoft_market/features/wishlist/presentation/wishlist_screen.dart';
import 'package:dksoft_market/features/home/home_screen.dart';
import 'package:dksoft_market/features/onboarding/onboarding_screen.dart';
import 'package:dksoft_market/features/products/presentation/product_screen.dart';
import 'package:dksoft_market/features/profile/presentation/profile_screen.dart';
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
  dealers,
  checkout,
  orders,
  orderDetails,
  orderTracking,
  profile,
  login,
  signup,
}

const _protectedPaths = ['/profile', '/orders'];

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final path = state.matchedLocation;
      final isAuthRoute = path == '/login' || path == '/signup';
      final isProtectedRoute = _protectedPaths.any(
        (route) => path.startsWith(route),
      );

      if (!isLoggedIn && isProtectedRoute) {
        return Uri(
          path: '/login',
          queryParameters: {'from': state.uri.toString()},
        ).toString();
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
        pageBuilder: (context, state) =>
            MaterialPage(fullscreenDialog: true, child: LoginScreen()),
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
                    path: '/cart',
                    name: AppRoute.cart.name,
                    builder: (context, state) => CartScreen(),
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        path: 'dealers',
                        name: AppRoute.dealers.name,
                        pageBuilder: (context, state) => MaterialPage(
                          fullscreenDialog: true,
                          child: ChooseDealerScreen(),
                        ),
                        routes: [
                          GoRoute(
                            parentNavigatorKey: _rootNavigatorKey,
                            path: 'checkout',
                            name: AppRoute.checkout.name,
                            builder: (context, state) {
                              return CheckoutScreen();
                            },
                          ),
                        ],
                      ),
                    ],
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
                path: '/orders',
                name: AppRoute.orders.name,
                builder: (context, state) => OrdersScreen(),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: ':orderId',
                    name: AppRoute.orderDetails.name,
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId']!;
                      return OrderDetailsScreen(orderId: orderId);
                    },
                    routes: [
                      GoRoute(
                        parentNavigatorKey: _rootNavigatorKey,
                        path: 'tracking',
                        name: AppRoute.orderTracking.name,
                        pageBuilder: (context, state) {
                          final orderId = state.pathParameters['orderId']!;
                          return MaterialPage(
                            fullscreenDialog: true,
                            child: OrderTrackingScreen(orderId: orderId),
                          );
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
