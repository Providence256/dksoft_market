import 'package:dksoft_market/features/authentication/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the signed-in user carries the `client` custom claim set by
/// the setClientRoleClaim Cloud Function (false when signed out).
/// Rebuilds whenever the Firebase auth state changes — login, logout, or
/// switching accounts.
final currentUserIsClientProvider = FutureProvider.autoDispose<bool>((
  ref,
) async {
  final user = await ref.watch(authStateChangesProvider.future);
  if (user == null) return false;
  return ref.watch(authRepositoryProvider).currentUserIsClient();
});
