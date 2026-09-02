import 'package:dksoft_market/features/wishlist/data/local/local_wishlist_repository.dart';
import 'package:dksoft_market/features/wishlist/domain/wishlist.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastWishlistRepository implements LocalWishlistRepository {
  SembastWishlistRepository(this.db);

  final store = StoreRef.main();

  final Database db;

  static Future<Database> createDatabase(String filename) async {
    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
    } else {
      return databaseFactoryWeb.openDatabase(filename);
    }
  }

  static Future<SembastWishlistRepository> makeDefault() async {
    return SembastWishlistRepository(await createDatabase('nyumbani.db'));
  }

  static const wishlistItemsKey = 'wishlistItems';

  @override
  Future<Wishlist> fetchWishlist() async {
    final wishlistJson =
        await store.record(wishlistItemsKey).get(db) as String?;

    if (wishlistJson != null) {
      return Wishlist.fromJson(wishlistJson);
    } else {
      return Wishlist();
    }
  }

  @override
  Future<void> setWishlist(Wishlist wishlist) {
    return store.record(wishlistItemsKey).put(db, wishlist.toJson());
  }

  @override
  Stream<Wishlist> watchWishlist() {
    final record = store.record(wishlistItemsKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return Wishlist.fromJson(snapshot.value as String);
      } else {
        return Wishlist();
      }
    });
  }
}
