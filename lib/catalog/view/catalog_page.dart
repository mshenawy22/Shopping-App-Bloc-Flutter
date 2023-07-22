import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shopping_cart/cart/cart.dart';
import 'package:flutter_shopping_cart/catalog/catalog.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CatalogAppBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          BlocBuilder<CatalogBloc, CatalogState>(
            builder: (context, state) {
              return switch (state) {
                CatalogLoading() => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                CatalogError() => const SliverFillRemaining(
                    child: Text('Something went wrong!'),
                  ),
                CatalogLoaded() => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => CatalogListItem(
                        state.catalog.getByPosition(index),
                      ),
                      childCount: state.catalog.itemNames.length,
                    ),
                  )
              };
            },
          ),
        ],
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({required this.item, super.key});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return
                 TextButton(
                  style: TextButton.styleFrom(
                    disabledForegroundColor: theme.primaryColor,
                  ),
                  onPressed:
                  // isInCart
                  //     ? () => context.read<CartBloc>().add(CartItemRemoved(item))
                  //     :
                  () => context.read<CartBloc>().add(CartItemAdded(item)),
                  child:
                    // isInCart
                    //   ?
                      const Icon(Icons.add, semanticLabel: 'Add')
                      // ? Text('+ ${state.cart.itemsWithQuantity[item]}')
                      // : const Text('ADD'),
                );
              },
            );
      }
  }


class quantityDisplayed extends StatelessWidget {
  const quantityDisplayed({required this.item, super.key});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return switch (state) {
        CartLoading() => const CircularProgressIndicator(),
        CartError() => const Text('Something went wrong!'),
        CartLoaded() => Builder(
        builder: (context) {
        return
          Text('${state.cart.itemsWithQuantity[item]??0}');
        },
        )
      };
      },
    );
  }
}
class RemoveButton extends StatelessWidget {
  const RemoveButton({required this.item, super.key});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return  Builder(
              builder: (context) {
                return TextButton(
                  style: TextButton.styleFrom(
                    disabledForegroundColor: theme.primaryColor,
                  ),
                  onPressed:
                  () => context.read<CartBloc>().add(CartItemRemoved(item)),
                  child:
                      // ? const Icon(Icons.check, semanticLabel: 'Remove')
                      // ? Text('+ ${state.cart.itemsWithQuantity[item]}')
                      const Icon(Icons.remove, semanticLabel: 'Remove'),
                );
              },
            );

      },
    );
  }
}

class CatalogAppBar extends StatelessWidget {
  const CatalogAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: const Text('Catalog'),
      floating: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => Navigator.of(context).pushNamed('/cart'),
        ),
      ],
    );
  }
}

class CatalogListItem extends StatelessWidget {
  const CatalogListItem(this.item, {super.key});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.titleLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(aspectRatio: 1, child: ColoredBox(color: item.color)),
            const SizedBox(width: 24),
            Expanded(child: Text(item.name, style: textTheme)),
            const SizedBox(width: 24),
            AddButton(item: item),
            quantityDisplayed(item: item),
            RemoveButton(item: item),

          ],
        ),
      ),
    );
  }
}
