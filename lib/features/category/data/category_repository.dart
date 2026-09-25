import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market/features/category/domain/category_modal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_repository.g.dart';

class CategoryRepository {
  CategoryRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static String categoriesPath() => 'categories';
  static String categoryPath(String id) => 'categories/$id';

  Future<List<CategoryModal>> fetchCategoryList() async {
    final ref = _categoriesRef();
    final snapshot = await ref.get();

    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  Stream<List<CategoryModal>> watchCategoriesList() {
    final ref = _categoriesRef();
    return ref.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList(),
    );
  }

  Future<CategoryModal?> fetchCategory(String id) async {
    final ref = _categoryRef(id);
    final snapshot = await ref.get();
    return snapshot.data();
  }

  Stream<CategoryModal?> watchCategory(String id) {
    final ref = _categoryRef(id);

    return ref.snapshots().map((snapshot) => snapshot.data());
  }

  DocumentReference<CategoryModal> _categoryRef(String id) => _firestore
      .doc(categoryPath(id))
      .withConverter(
        fromFirestore: (doc, _) => CategoryModal.fromMap(doc.data()!),
        toFirestore: (CategoryModal category, options) => category.toMap(),
      );

  Query<CategoryModal> _categoriesRef() {
    return _firestore
        .collection(categoriesPath())
        .withConverter(
          fromFirestore: (doc, _) {
            return CategoryModal.fromMap(doc.data()!);
          },
          toFirestore: (CategoryModal category, options) => category.toMap(),
        );
  }
}

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(Ref ref) {
  return CategoryRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<CategoryModal>> categoriesListStream(Ref ref) {
  final repository = ref.watch(categoryRepositoryProvider);

  return repository.watchCategoriesList();
}

@riverpod
Stream<CategoryModal?> categoryStream(Ref ref, String id) {
  final repository = ref.watch(categoryRepositoryProvider);

  return repository.watchCategory(id);
}

@riverpod
Future<List<CategoryModal>> categoriesListFuture(Ref ref) {
  final repository = ref.watch(categoryRepositoryProvider);

  return repository.fetchCategoryList();
}

@riverpod
Future<CategoryModal?> categoryFuture(Ref ref, String id) {
  final repository = ref.watch(categoryRepositoryProvider);

  return repository.fetchCategory(id);
}
