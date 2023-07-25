import 'package:equatable/equatable.dart';
import 'package:flutter_shopping_cart/catalog/catalog.dart';

class Cart extends Equatable {
  const Cart({this.items = const <Item>[] , this.itemsWithQuantity = const {} });

  final List<Item> items;
  final Map<Item, int> itemsWithQuantity;

  int get totalPrice {
    // return items.fold(0, (total, current) => total + current.price);
    int totalPrice = 0;
    // Iterate through all items and their quantities
    itemsWithQuantity.forEach((item, quantity) {
      // Calculate the price for the current item by multiplying its price with the quantity
      int itemPrice = item.price * quantity;
      totalPrice += itemPrice;
    });

    return totalPrice;
  }

  @override
  List<Object> get props => [items];
}
