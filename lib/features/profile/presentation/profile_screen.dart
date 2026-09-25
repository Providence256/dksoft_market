import 'package:dksoft_market/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market/features/profile/presentation/widgets/logout_tile.dart';
import 'package:dksoft_market/features/profile/presentation/widgets/menu_section.dart';
import 'package:dksoft_market/features/profile/presentation/widgets/profile_header.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/constants/app_colors.dart';
import 'package:dksoft_market/utils/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: ProfileHeader(user: user),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: Sizes.p32),
          children: [
            const SizedBox(height: Sizes.p24),
            MenuSection(
              title: 'Mon activité',
              items: [
                MenuItemData(
                  icon: Icons.storefront_outlined,
                  color: AppColors.info,
                  label: 'Magasins suivis',
                  subtitle: 'Retrouvez vos commerçants favoris',
                  onTap: () => _showComingSoon(context, 'Magasins suivis'),
                ),
              ],
            ),
            const SizedBox(height: Sizes.p20),
            MenuSection(
              title: 'Devenir partenaire',
              items: [
                MenuItemData(
                  icon: Icons.handshake_outlined,
                  color: AppColors.primary,
                  label: 'Devenir dealer',
                  subtitle: 'Livrez et gérez des commandes près de chez vous',
                  onTap: () => _showComingSoon(context, 'Devenir dealer'),
                ),
                MenuItemData(
                  icon: Icons.storefront_rounded,
                  color: AppColors.primary,
                  label: 'Devenir vendeur',
                  subtitle: 'Ouvrez votre boutique sur dksoft_market',
                  onTap: () => _showComingSoon(context, 'Devenir vendeur'),
                ),
                MenuItemData(
                  icon: Icons.two_wheeler_outlined,
                  color: AppColors.primary,
                  label: 'Devenir livreur',
                  subtitle: 'Gagnez de l\'argent en livrant des commandes',
                  onTap: () => _showComingSoon(context, 'Devenir livreur'),
                ),
              ],
            ),
            const SizedBox(height: Sizes.p20),
            MenuSection(
              title: 'Général',
              items: [
                MenuItemData(
                  icon: Icons.notifications_outlined,
                  color: AppColors.warning,
                  label: 'Notifications',
                  onTap: () => _showComingSoon(context, 'Notifications'),
                ),
                MenuItemData(
                  icon: Icons.settings_outlined,
                  color: AppColors.textSecondaryLight,
                  label: 'Paramètres',
                  onTap: () => _showComingSoon(context, 'Paramètres'),
                ),
                MenuItemData(
                  icon: Icons.help_outline_rounded,
                  color: AppColors.success,
                  label: "Centre d'aide et support",
                  onTap: () => _showComingSoon(context, 'Centre d\'aide'),
                ),
              ],
            ),
            const SizedBox(height: Sizes.p24),
            LogoutTile(onTap: () => _confirmLogout(context, ref)),
            const SizedBox(height: Sizes.p24),
            Center(
              child: Text(
                'dksoft_market · v1.0.0',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: AppColors.textHintLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label — bientôt disponible.')));
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Se déconnecter ?'),
        content: const Text(
          'Vous devrez vous reconnecter pour accéder à votre compte.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(authRepositoryProvider).signOut();
    if (context.mounted) context.goNamed(AppRoute.home.name);
  }
}
