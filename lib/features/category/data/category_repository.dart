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
