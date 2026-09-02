import 'package:dksoft_market/features/wishlist/data/local/local_wishlist_repository.dart';
import 'package:dksoft_market/features/wishlist/data/local/sembast_wishlist_repository.dart';
import 'package:dksoft_market/firebase_options.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final localwishListRepository = await SembastWishlistRepository.makeDefault();
  runApp(
    ProviderScope(
      overrides: [
        localWishlistRepositoryProvider.overrideWithValue(
          localwishListRepository,
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return ToastificationWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'DkSoft-Market',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: goRouter,
      ),
    );
  }
}
