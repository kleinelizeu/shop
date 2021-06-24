import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  CartItemWidget(this.cartItem);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Você tem certeza?"),
            content: Text("Quer remover o item do carrinho?"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text("Não"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text("Sim"),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false)
            .removeItem(cartItem.productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text("${cartItem.price}"),
                ),
              ),
            ),
            title: Text(cartItem.title),
            subtitle: Text("Total: R\$ ${cartItem.price * cartItem.quantity}"),
            trailing: Text("${cartItem.quantity}x"),
          ),
        ),
      ),
    );
  }
}
