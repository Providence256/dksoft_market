import 'package:dksoft_market/features/authentication/data/auth_repository.dart';
import 'package:dksoft_market/features/authentication/domain/account_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._authRepository) : super(const AsyncData(null));

  final AuthRepository _authRepository;

  Future<bool> signIn({required String phone, required String password}) async {
    state = const AsyncLoading();

    try {
      await _authRepository.signInWithPhoneAndPassword(
        phone: phone,
        password: password,
      );
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(_authRepository.mapAuthError(error), stackTrace);
      return false;
    }
  }

  Future<bool> signUp({
    required String fullName,
    required String phone,
    required String password,
    required AccountType accountType,
    required String commune,
    String? address,
    String? email,
  }) async {
    state = const AsyncLoading();

    try {
      await _authRepository.signUpWithPhoneAndPassword(
        fullName: fullName,
        phone: phone,
        password: password,
        accountType: accountType,
        commune: commune,
        address: address,
        email: email,
      );
      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(_authRepository.mapAuthError(error), stackTrace);
      return false;
    }
  }
}

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AsyncValue<void>>((ref) {
      return AuthController(ref.watch(authRepositoryProvider));
    });
