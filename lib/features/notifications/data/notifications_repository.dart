import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsRepository {
  NotificationsRepository(this._messaging, this._firestore);
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;

  bool get _isSupportedPlatform => !kIsWeb && Platform.isAndroid;

  Future<void> syncTokenForUser(String uid) async {
    if (!_isSupportedPlatform) return;

    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    final token = await _messaging.getToken();
    if (token == null) return;

    await _firestore.collection('users').doc(uid).set({
      'fcmToken': token,
    }, SetOptions(merge: true));
  }

  Stream<String> onTokenRefresh() => _messaging.onTokenRefresh;
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return NotificationsRepository(
    FirebaseMessaging.instance,
    FirebaseFirestore.instance,
  );
});
