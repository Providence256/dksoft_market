import 'package:dksoft_market/core/data/test_products.dart';
import 'package:dksoft_market/features/cart/domain/item.dart';
import 'package:dksoft_market/features/home/domain/product_modal.dart';
import 'package:dksoft_market/features/home/domain/product_variation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductRepository {
  final List<ProductModal> _products = kTestProducts;

  List<ProductModal> getProductsList() => _products;

  ProductModal? getProduct(String id) {
    return _getPproduct(_products, id);
  }

  Future<List<ProductModal>> fetchProductList() async {
    return Future.value(_products);
  }

  Stream<List<ProductModal>> watchProductsList() async* {
    yield _products.where((product) => product.reduction == 0).toList();
  }

  Stream<List<ProductModal>> watchAllproducts() async* {
    yield _products;
  }

  Stream<ProductModal?> watchProduct(String id) {
    return watchAllproducts().map((products) => _getPproduct(products, id));
  }

  Stream<List<ProductModal>> watchDiscountProducts() async* {
    final discountProducts = _products
        .where((product) => product.reduction != 0)
        .toList();

    yield discountProducts;
  }

  Stream<ProductVariation?> watchProductVariation(
    String productId,
    String variationId,
  ) {
    return watchAllproducts().map(
      (products) => _getProductVariation(products, productId, variationId),
    );
  }

  static ProductModal? _getPproduct(List<ProductModal> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  static ProductVariation? _getProductVariation(
    List<ProductModal> products,
    String productId,
    String variationId,
  ) {
    try {
      final product = _getPproduct(products, productId);

      return product!.variations.firstWhere(
        (variation) => variation.id == variationId,
      );
    } catch (e) {
      return null;
    }
  }
}

final fakeProductsRepositoryProvider = Provider<FakeProductRepository>((ref) {
  return FakeProductRepository();
});

final watchproductsProvider = StreamProvider<List<ProductModal>>((ref) {
  final repository = ref.watch(fakeProductsRepositoryProvider);

  return repository.watchProductsList();
});

typedef ProductVariationKey = ({String productId, String? variationId});

final productVariationProvider = StreamProvider.autoDispose
    .family<ProductVariation?, ProductVariationKey>((ref, key) {
      final proId = key.productId;
      final varId = key.variationId;
      final repository = ref.watch(fakeProductsRepositoryProvider);

      return repository.watchProductVariation(proId, varId!);
    });

final discountProductProvider = StreamProvider<List<ProductModal>>((ref) {
  final repository = ref.watch(fakeProductsRepositoryProvider);

  return repository.watchDiscountProducts();
});

final watchProductProvider = StreamProvider.autoDispose
    .family<ProductModal?, String>((ref, id) {
      final repository = ref.watch(fakeProductsRepositoryProvider);

      return repository.watchProduct(id);
    });
