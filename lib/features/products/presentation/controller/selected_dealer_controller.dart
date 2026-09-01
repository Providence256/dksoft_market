import 'package:flutter_riverpod/legacy.dart';

/// Dealer chosen by the client on the current product screen, via
/// [DealerPickerSheet]. Reset automatically when the product screen is
/// left (autoDispose) since a new product means a new set of offers.
final selectedDealerProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});
