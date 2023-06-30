import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../models/cart_attributes.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttr> _cartItems = {};

  Map<String, CartAttr> get getCartItem {
    return _cartItems;
  }

  double get totalPrice {
    var total = 0.00;

    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }

  void addProductToCart(
      String productName,
      String productId,
      List imageUrl,
      int quantity,
      int productQuantity,
      double price,
      String vendorId,
      String productSize,
      Timestamp scheduleDate) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (exitingCart) => CartAttr(
              productName: exitingCart.productName,
              productId: exitingCart.productId,
              imageUrl: exitingCart.imageUrl,
              quantity: exitingCart.quantity + 1,
              productQuantity: exitingCart.productQuantity,
              price: exitingCart.price,
              vendorId: exitingCart.vendorId,
              productSize: exitingCart.productSize,
              scheduleDate: exitingCart.scheduleDate));

      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartAttr(
              productName: productName,
              productId: productId,
              imageUrl: imageUrl,
              quantity: quantity,
              productQuantity: productQuantity,
              price: price,
              vendorId: vendorId,
              productSize: productSize,
              scheduleDate: scheduleDate));

      notifyListeners();
    }
  }

  void increament(CartAttr cartAttr) {
    cartAttr.increase();

    notifyListeners();
  }

  void decreaMent(CartAttr cartAttr) {
    cartAttr.decrease();

    notifyListeners();
  }

  removeItem(productId) {
    _cartItems.remove(productId);

    notifyListeners();
  }

  removeAllItem() {
    _cartItems.clear();

    notifyListeners();
  }
}
