import 'package:dksoft_market/features/authentication/application/is_client_provider.dart';
import 'package:dksoft_market/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wraps the whole app so only guests (signed out) or accounts carrying
/// the `client` custom claim can use it. A dealer account that signs in
/// here (shared auth project, wrong app) sees an explanation instead of
/// the shop, and can sign back out. Unlike the dealer app, this app
/// supports guest browsing, so a signed-out user is always let through.
class RoleGuard extends ConsumerWidget {
  const RoleGuard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateChangesProvider);

    return userAsync.when(
      loading: () => child,
      error: (_, _) => child,
      data: (user) {
        if (user == null) return child; // Guest: browsing is allowed.

        final isClientAsync = ref.watch(currentUserIsClientProvider);

        return isClientAsync.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, _) => _AccessMessage(
            title: 'Une erreur est survenue',
            message: '$error',
          ),
          data: (isClient) {
            if (isClient) return child;
            return const _AccessMessage(
              title: 'Application réservée aux clients',
              message:
                  'Ce compte est enregistré avec un autre rôle (dealer, '
                  'commerçant...). Connectez-vous avec un compte client pour '
                  'utiliser Dksoft Market.',
            );
          },
        );
      },
    );
  }
}

class _AccessMessage extends ConsumerWidget {
  const _AccessMessage({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(Sizes.p20),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.block,
                    color: AppColors.error,
                    size: 40,
                  ),
                ),
                gapH12,
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                gapH8,
                Text(
                  message,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                gapH16,
                ElevatedButton(
                  onPressed: () => ref.read(authRepositoryProvider).signOut(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  child: Text(
                    'Se déconnecter',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
