import 'package:dksoft_market/features/home/domain/product_modal.dart';

class PricingCalculator {
  // Selling price after discount
  static double calculateSellingPrice(
    double productPrice,
    int discountPercent,
  ) {
    double discount = (discountPercent / 100) * productPrice;
    double sellingPrice = productPrice - discount;

    return sellingPrice;
  }

  // get product selling price
  static String getSellingPrice(ProductModal product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;
    double salePrice = 0.0;

    salePrice = calculateSellingPrice(product.price, product.reduction);

    // if no variation return simple price
    if (product.variations.isEmpty) {
      return product.reduction > 0 ? '\$$salePrice' : '\$${product.price}';
    } else {
      // calculate the smallest and largest prices among variations

      for (var variation in product.variations) {
        salePrice = calculateSellingPrice(variation.price, product.reduction);

        double priceToConsider = product.reduction > 0
            ? salePrice
            : variation.price;

        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }

        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }
      if (smallestPrice == largestPrice) {
        return '\$$largestPrice';
      } else {
        return '\$$smallestPrice - \$$largestPrice';
      }
    }
  }

  // getting the price after deduction
  static String getProoductprice(ProductModal product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    //no variation return simple price
    if (product.variations.isEmpty) {
      return '\$${product.price}';
    } else {
      for (var variation in product.variations) {
        double priceToConsider = variation.price;

        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }

        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }
      if (smallestPrice == largestPrice) {
        return '\$$largestPrice';
      } else {
        return '\$$smallestPrice - \$$largestPrice';
      }
    }
  }
}
