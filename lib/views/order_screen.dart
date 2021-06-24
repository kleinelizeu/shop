import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item_widget.dart';

class OrderScreen extends StatelessWidget {
  // bool _isLoading = true;

  /* Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<Orders>(context, listen: false).loadOrders();
  }
*/
  /*

  @override
  void initState() {
    Provider.of<Orders>(context, listen: false).loadOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  */

  @override
  Widget build(BuildContext context) {
//    final Orders orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Pedidos"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).loadOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return Center(
              child: Text("Ocorreu um erro inesperado"),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, orders, child) {
                return ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => OrderItemWidget(
                    orders.items[i],
                  ),
                );
              },
            );
          }
        },
      ),

      /* RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (ctx, i) => OrderItemWidget(
                  orders.items[i],
                ),
              ),
      ),*/
    );
  }
}
