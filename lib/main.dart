import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market/features/notifications/data/notifications_repository.dart';
import 'package:dksoft_market/features/wishlist/data/local/local_wishlist_repository.dart';
import 'package:dksoft_market/features/wishlist/data/local/sembast_wishlist_repository.dart';
import 'package:dksoft_market/firebase_options.dart';
import 'package:dksoft_market/routing/app_router.dart';
import 'package:dksoft_market/utils/themes/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupEmulators();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((message) {
    final notification = message.notification;
    if (notification == null) return;
    toastification.show(
      title: Text(notification.title ?? 'Notification'),
      description: Text(notification.body ?? ''),
      type: ToastificationType.info,
      autoCloseDuration: const Duration(seconds: 4),
    );
  });

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

    ref.listen(authStateChangesProvider, (previous, next) {
      final user = next.value;
      if (user != null) {
        ref.read(notificationsRepositoryProvider).syncTokenForUser(user.uid);
      }
    });
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

Future<void> setupEmulators() async {
  await FirebaseAuth.instance.useAuthEmulator('127.0.0.2', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.2', 8080);
  await FirebaseStorage.instance.useStorageEmulator('127.0.0.2', 9199);
}
