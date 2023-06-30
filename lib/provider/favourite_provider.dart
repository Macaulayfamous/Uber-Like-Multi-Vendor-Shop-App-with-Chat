import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:uber_app/models/favorite_models.dart';

import '../models/cart_attributes.dart';

class FavouriteProvider with ChangeNotifier {
  Map<String, WishListModels> _cartItems = {};

  Map<String, WishListModels> get getwishItem {
    return _cartItems;
  }

  void addProductToWish(
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
          (exitingCart) => WishListModels(
              productName: exitingCart.productName,
              productId: exitingCart.productId,
              imageUrl: exitingCart.imageUrl,
              quantity: exitingCart.quantity,
              productQuantity: exitingCart.productQuantity,
              price: exitingCart.price,
              vendorId: exitingCart.vendorId,
              productSize: exitingCart.productSize,
              scheduleDate: exitingCart.scheduleDate));

      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => WishListModels(
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

  removeItem(productId) {
    _cartItems.remove(productId);

    notifyListeners();
  }

  removeAllItem() {
    _cartItems.clear();

    notifyListeners();
  }
}
