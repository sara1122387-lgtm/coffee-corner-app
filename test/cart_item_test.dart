import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_corner_app/shared/models/cart_item.dart';

void main() {
  group('CartItem', () {
    final item = CartItem(
      productId: 'coffee-001',
      productName: 'Latte',
      basePrice: 5000,
      selectedSize: 'Medium',
      sizePriceDelta: 1000,
      sugarLevel: 'Regular',
      selectedAddOns: const [
        CartAddOn(name: 'Caramel', price: 500),
        CartAddOn(name: 'Extra Shot', price: 1000),
      ],
      quantity: 2,
    );

    test('calculates unit price correctly', () {
      expect(item.unitPrice, 7500);
    });

    test('calculates total price correctly', () {
      expect(item.totalPrice, 15000);
    });

    test('copyWith updates quantity only', () {
      final updated = item.copyWith(quantity: 3);

      expect(updated.quantity, 3);
      expect(updated.unitPrice, 7500);
      expect(updated.totalPrice, 22500);
      expect(updated.selectedSize, 'Medium');
    });

    test('same configuration ignores add-on order', () {
      final anotherItem = CartItem(
        productId: 'coffee-001',
        productName: 'Latte',
        basePrice: 5000,
        selectedSize: 'Medium',
        sizePriceDelta: 1000,
        sugarLevel: 'Regular',
        selectedAddOns: const [
          CartAddOn(name: 'Extra Shot', price: 1000),
          CartAddOn(name: 'Caramel', price: 500),
        ],
        quantity: 1,
      );

      expect(item.hasSameConfiguration(anotherItem), isTrue);
    });

    test('different configurations are not equal', () {
      final anotherItem = item.copyWith();

      final differentSugar = CartItem(
        productId: item.productId,
        productName: item.productName,
        basePrice: item.basePrice,
        selectedSize: item.selectedSize,
        sizePriceDelta: item.sizePriceDelta,
        sugarLevel: 'Low sugar',
        selectedAddOns: item.selectedAddOns,
        quantity: 1,
      );

      expect(item.hasSameConfiguration(anotherItem), isTrue);
      expect(item.hasSameConfiguration(differentSugar), isFalse);
    });
  });
}
