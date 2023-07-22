import 'dart:async';

import 'package:flutter_shopping_cart/catalog/catalog.dart';

const _delay = Duration(milliseconds: 800);

const _catalog = [
  'Code Smell',
  'Control Flow',
  'Interpreter',
  'Recursion',
  'Sprint',
  'Heisenbug',
  'Spaghetti',
  'Hydra Code',
  'Off-By-One',
  'Scope',
  'Callback',
  'Closure',
  'Automata',
  'Bit Shift',
  'Currying',
];

class ShoppingRepository {
  final _items = <Item>[];
  final itemswithquantity = <Item,int>{};

  Future<List<String>> loadCatalog() => Future.delayed(_delay, () => _catalog);

  Future<List<Item>> loadCartItems() => Future.delayed(_delay, () => _items);
  Future<Map<Item,int>> loadCartItemsWithQuantity() => Future.delayed(_delay, () => itemswithquantity);

  void addItemToCart(Item item) => _items.add(item);

  void addItemToCartQuantity(Item item) => itemswithquantity.update(item, (oldvalue) => oldvalue+1 , ifAbsent: ()=>1) ;

  void removeItemFromCart(Item item) => _items.remove(item);
}
