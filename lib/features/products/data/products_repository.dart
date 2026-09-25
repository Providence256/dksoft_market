import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dksoft_market/features/products/domain/product_modal.dart';
import 'package:dksoft_market/features/products/domain/product_variation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_repository.g.dart';

typedef ProductVariationKey = ({String productId, String? variationId});

class ProductsRepository {
  ProductsRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String productsPath() => 'products';

  static String productPath(String id) => 'products/$id';

  Future<List<ProductModal>> fetchProductsList() async {
    final ref = _productsRef();
    final snapshot = await ref.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  Stream<List<ProductModal>> watchProductsList() {
    final ref = _productsRef();
    return ref
        .where('reduction', isEqualTo: 0)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList(),
        );
  }

  Future<ProductModal?> fetchProduct(String id) async {
    final ref = _productRef(id);
    final snapshot = await ref.get();
    return snapshot.data();
  }

  Future<ProductVariation?> getProductVariation(
    String productId,
    String variationId,
  ) async {
    final product = await fetchProduct(productId);

    if (product == null) {
      return null;
    }

    return _getProductVariation(product, variationId);
  }

  Stream<ProductModal?> watchProduct(String id) {
    final ref = _productRef(id);

    return ref.snapshots().map((snapshot) => snapshot.data());
  }

  Stream<List<ProductModal>> watchDiscountProducts() {
    final ref = _productsRef();
    return ref
        .where('reduction', isNotEqualTo: 0)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList(),
        );
  }

  Stream<List<ProductModal>> watchProductsSubCategoryStream(
    String subCategoryId,
  ) {
    return _productsRef()
        .where('subcategoryId', isEqualTo: subCategoryId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  DocumentReference<ProductModal> _productRef(String id) => _firestore
      .doc(productPath(id))
      .withConverter(
        fromFirestore: (doc, _) => ProductModal.fromMap(doc.data()!),
        toFirestore: (ProductModal product, options) => product.toMap(),
      );

  Query<ProductModal> _productsRef() {
    return _firestore
        .collection(productsPath())
        .withConverter(
          fromFirestore: (doc, _) {
            return ProductModal.fromMap(doc.data()!);
          },
          toFirestore: (ProductModal product, options) => product.toMap(),
        )
        .orderBy('id');
  }

  static ProductVariation? _getProductVariation(
    ProductModal product,
    String variationId,
  ) {
    try {
      return product.variations.firstWhere((v) => v.id == variationId);
    } catch (e) {
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
ProductsRepository productsRepository(Ref ref) {
  return ProductsRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<ProductModal>> productsListStream(Ref ref) {
  final repository = ref.watch(productsRepositoryProvider);

  return repository.watchProductsList();
}

@riverpod
Stream<List<ProductModal>> productsDiscountStream(Ref ref) {
  final repository = ref.watch(productsRepositoryProvider);

  return repository.watchDiscountProducts();
}

@riverpod
Future<List<ProductModal>> productsListFuture(Ref ref) {
  final repository = ref.watch(productsRepositoryProvider);

  return repository.fetchProductsList();
}

@riverpod
Stream<ProductModal?> productStream(Ref ref, String id) {
  final repository = ref.watch(productsRepositoryProvider);

  return repository.watchProduct(id);
}

@riverpod
Stream<List<ProductModal>> productsBySubCateStream(
  Ref ref,
  String subCategoryId,
) {
  final repository = ref.watch(productsRepositoryProvider);

  return repository.watchProductsSubCategoryStream(subCategoryId);
}

@riverpod
Future<ProductModal?> productFuture(Ref ref, String id) {
  final repository = ref.watch(productsRepositoryProvider);

  return repository.fetchProduct(id);
}

@riverpod
Future<ProductVariation?> productVariation(
  Ref ref,
  ProductVariationKey key,
) async {
  final productId = key.productId;
  final variationId = key.variationId;
  final repository = ref.watch(productsRepositoryProvider);

  return repository.getProductVariation(productId, variationId!);
}
