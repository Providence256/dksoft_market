import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market/features/authentication/domain/app_user.dart';
import 'package:dksoft_market/features/authentication/domain/firebase_app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth, this._firestore);
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static String usersPath() => 'users';

  AppUser? get currentUser => _convertUser(_auth.currentUser);

  Stream<List<AppUser>> users() {
    return _auth.userChanges().map(
      (user) => user != null ? [FirebaseAppUser(user)] : [],
    );
  }

  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map(_convertUser);
  }

  AppUser? _convertUser(User? user) =>
      user != null ? FirebaseAppUser(user) : null;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance);
}

@Riverpod()
Stream<AppUser?> authStateChanges(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
