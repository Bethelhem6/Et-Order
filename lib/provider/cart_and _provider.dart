// ignore_for_file: file_names, prefer_final_fields

import 'package:flutter/material.dart';

class Carts with ChangeNotifier {
  // final String? productId;
  final String id, image, title;
  final int quantity;
  final double price;
  // final Color color;
  Carts({
    // required this.productId,
    required this.image,
    required this.title,
    required this.price,
    required this.quantity,
    required this.id,
  });
  Map<String, dynamic> toMap() {
    return {
      "image": image,
      "title": id,
      "price": price,
      "quantity": quantity,
      "id": title
    };
  }
}

class CartProvider with ChangeNotifier {
  Map<String, Carts> _cartList = {};
  Map<String, Carts> get cartList => _cartList;

  double get subTotal {
    double total = 0.0;

    _cartList.forEach((key, value) {
      total = total + value.quantity * value.price;
    });
    return total;
  }

// double get subtotal =>_
//       _cartList.fold(0, (total, current) => total + current.price);
  // String get subtotalString => subTotal.toStringAsFixed(2);

  double _deliveryFee(subtotal) {
    if (subtotal < 2600 && subtotal > 700) {
      return 50.0;
    }
    if (subtotal == 0) {
      return 0.0;
    }
    if (subtotal > 2500) {
      return 30.0;
    } else {
      return 100;
    }
  }

  double get deliveryFee => _deliveryFee(subTotal);

  double _total(subtotal, deliveryFee) {
    return subtotal + deliveryFee(subtotal);
  }

  double get totalString => _total(subTotal, deliveryFee);

  void addToCart(String title, String id, String image, double price) {
    if (_cartList.containsKey(id)) {
      _cartList.update(
          id,
          (value) => Carts(
              id: value.id,
              image: image,
              title: value.title,
              price: value.price,
              quantity: value.quantity + 1));
    } else {
      _cartList.putIfAbsent(
        id,
        () => Carts(
            id: id,
            // productId: DateTime.now().toIso8601String(),
            image: image,
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void decremenFromCart(String title, String id, String image, double price) {
    if (_cartList.containsKey(id)) {
      _cartList.update(
        id,
        (value) => Carts(
            id: value.id,
            image: image,
            title: value.title,
            price: value.price,
            quantity: value.quantity - 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _cartList.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _cartList.clear();
    notifyListeners();
  }
}
