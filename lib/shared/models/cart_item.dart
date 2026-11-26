class CartAddOn {
  final String name;
  final int price;

  const CartAddOn({required this.name, required this.price});
}

class CartItem {
  final String productId;
  final String productName;
  final int basePrice;

  final String? selectedSize;
  final int sizePriceDelta;
  final String sugarLevel;

  final List<CartAddOn> selectedAddOns;
  final int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.basePrice,
    this.selectedSize,
    this.sizePriceDelta = 0,
    required this.sugarLevel,
    List<CartAddOn> selectedAddOns = const [],
    required this.quantity,
  }) : selectedAddOns = List.unmodifiable(selectedAddOns);

  int get unitPrice {
    final addOnsPrice = selectedAddOns.fold<int>(
      0,
      (total, addOn) => total + addOn.price,
    );

    return basePrice + sizePriceDelta + addOnsPrice;
  }

  int get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toOrderJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'selected_size': selectedSize,
      'sugar_level': sugarLevel,
      'selected_add_ons': selectedAddOns.map((addOn) => addOn.name).toList(),
    };
  }

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      productName: productName,
      basePrice: basePrice,
      selectedSize: selectedSize,
      sizePriceDelta: sizePriceDelta,
      sugarLevel: sugarLevel,
      selectedAddOns: selectedAddOns,
      quantity: quantity ?? this.quantity,
    );
  }

  bool hasSameConfiguration(CartItem other) {
    if (productId != other.productId ||
        basePrice != other.basePrice ||
        selectedSize != other.selectedSize ||
        sizePriceDelta != other.sizePriceDelta ||
        sugarLevel != other.sugarLevel ||
        selectedAddOns.length != other.selectedAddOns.length) {
      return false;
    }

    final thisAddOns =
        selectedAddOns.map((addOn) => '${addOn.name}:${addOn.price}').toList()
          ..sort();

    final otherAddOns =
        other.selectedAddOns
            .map((addOn) => '${addOn.name}:${addOn.price}')
            .toList()
          ..sort();

    for (var i = 0; i < thisAddOns.length; i++) {
      if (thisAddOns[i] != otherAddOns[i]) {
        return false;
      }
    }

    return true;
  }
}
