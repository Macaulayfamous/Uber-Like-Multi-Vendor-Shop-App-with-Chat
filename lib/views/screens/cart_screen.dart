import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/cart_provider.dart';
import 'inner_screens/checkout_screen.dart';
import 'main_Screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        elevation: 0,
        title: Text(
          'Cart Screen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _cartProvider.removeAllItem();
            },
            icon: Icon(
              CupertinoIcons.delete,
            ),
          ),
        ],
      ),
      body: _cartProvider.getCartItem.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: _cartProvider.getCartItem.length,
              itemBuilder: (context, index) {
                final cartData =
                    _cartProvider.getCartItem.values.toList()[index];

                return Card(
                  child: SizedBox(
                    height: 200,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.network(cartData.imageUrl[0]),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cartData.productName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 5,
                                  ),
                                ),
                                Text(
                                  '\$${cartData.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 5,
                                    color: Colors.pink,
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: null,
                                  child: Text(
                                    cartData.productSize,
                                    style: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.pink,
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: cartData.quantity == 1
                                                ? null
                                                : () {
                                                    _cartProvider
                                                        .decreaMent(cartData);
                                                  },
                                            icon: Icon(
                                              CupertinoIcons.minus,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                          Text(
                                            cartData.quantity.toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          IconButton(
                                            onPressed: cartData
                                                        .productQuantity ==
                                                    cartData.quantity
                                                ? null
                                                : () {
                                                    _cartProvider
                                                        .increament(cartData);
                                                  },
                                            icon: Icon(
                                              CupertinoIcons.plus,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _cartProvider.removeItem(
                                          cartData.productId,
                                        );
                                      },
                                      icon: Icon(
                                        CupertinoIcons.cart_badge_minus,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Shopping Cart is Empty',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return MainScreen();
                      }));
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'CONTINUE SHOPPING',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _cartProvider.totalPrice == 0.00
          ? null
          : Container(
              height: 80,
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total: \$${_cartProvider.totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CheckoutScreen();
                      }));
                    },
                    child: Text(
                      "CHECKOUT",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
