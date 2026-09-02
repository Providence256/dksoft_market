import 'package:dksoft_market/core/data/test_categories.dart';
import 'package:dksoft_market/features/category/domain/category_modal.dart';
import 'package:dksoft_market/utils/validators/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryRepository {
  final _categories = InMemoryStore<List<CategoryModal>>(kTestCategory);

  List<CategoryModal> getCategoryList() {
    return _categories.value;
  }

  Future<List<CategoryModal>> fetchCategoriesList() async {
    return Future.value(_categories.value);
  }

  Stream<List<CategoryModal>> watchCategoriesList() {
    return _categories.stream;
  }

  Stream<CategoryModal?> watchCategory(String id) {
    return watchCategoriesList().map(
      (categories) => _getCategory(categories, id),
    );
  }

  static CategoryModal? _getCategory(
    List<CategoryModal> categories,
    String id,
  ) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final categoriesListProvider = StreamProvider.autoDispose<List<CategoryModal>>((
  ref,
) {
  final repository = ref.watch(categoryRepositoryProvider);

  return repository.watchCategoriesList();
});

final categoryProvider = StreamProvider.autoDispose
    .family<CategoryModal?, String>((ref, id) {
      final repository = ref.watch(categoryRepositoryProvider);

      return repository.watchCategory(id);
    });
