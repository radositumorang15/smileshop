import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import 'my_order_details_page.dart';

class MyOrdersPage extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      appBar: AppBar(
            backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text('My Orders'),
      ),
      body: Obx(() {
        if (orderController.orders.isEmpty) {
          return const Center(
            child: Text('No orders found.'),
          );
        }

        return ListView.builder(
          itemCount: orderController.orders.length,
          itemBuilder: (context, index) {
            final order = orderController.orders[index];

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text('Order #${order.id}'),
                subtitle: Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  orderController.selectOrder(order);
                  Get.to(() => MyOrderDetailsPage());
                },
              ),
            );
          },
        );
      }),
    );
  }
}
