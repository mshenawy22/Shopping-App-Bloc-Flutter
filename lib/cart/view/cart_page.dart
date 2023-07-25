import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shopping_cart/cart/cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});


  @override
  Widget build(BuildContext context) {
    final headlineRowStyle = Theme.of(context).
    textTheme.titleLarge?.copyWith(color: Colors.white , fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: ColoredBox(
        color: Colors.yellow,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 32, left: 32, top: 32 , bottom: 8),
              child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: ListTile(
                    tileColor : Colors.black.withOpacity(0.7),
                    leading:  Text('Qty', style: headlineRowStyle),
                    title: Text('Product', style: headlineRowStyle),
                    trailing: Text('Price', style: headlineRowStyle),
                  )),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: CartList(),
              ),
            ),
            Divider(height: 4, color: Colors.black),
            CartTotal()
          ],
        ),
      ),
    );
  }
}

class CartList extends StatelessWidget {
  const CartList({super.key});

  @override
  Widget build(BuildContext context) {
    final itemNameStyle = Theme.of(context).textTheme.titleLarge;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return switch (state) {
          CartLoading() => const CircularProgressIndicator(),
          CartError() => const Text('Something went wrong!'),
          CartLoaded() => ListView.separated(
              itemCount: state.cart.itemsWithQuantity.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = state.cart.itemsWithQuantity.keys.elementAt(index);
                return Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: ListTile(
                    leading: Text('${state.cart.itemsWithQuantity[item]!}' , style: itemNameStyle),
                    title: Text(item.name, style: itemNameStyle),
                    trailing:  Text( '\$${state.cart.itemsWithQuantity[item]! * item.price}' , style: itemNameStyle),
                    onLongPress: () {
                      context.read<CartBloc>().add(CartItemRemoved(item));
                    },
                  ),
                );
              },
            ),
        };
      },
    );
  }
}

class CartTotal extends StatelessWidget {
  const CartTotal({super.key});

  @override
  Widget build(BuildContext context) {
    final hugeStyle =
        Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 48);

    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return switch (state) {
                  CartLoading() => const CircularProgressIndicator(),
                  CartError() => const Text('Something went wrong!'),
                  CartLoaded() =>
                    Text('\$${state.cart.totalPrice}', style: hugeStyle),
                };
              },
            ),
            const SizedBox(width: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buying not supported yet.')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}
