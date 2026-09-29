import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  OnboardingRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _completedKey = 'onboardingCompleted';

  bool get isCompleted => _prefs.getBool(_completedKey) ?? false;

  Future<void> setCompleted() => _prefs.setBool(_completedKey, true);
}

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  throw UnimplementedError('onboardingRepositoryProvider must be overridden');
});
