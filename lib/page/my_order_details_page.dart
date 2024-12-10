import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';

class MyOrderDetailsPage extends StatelessWidget {
  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    final selectedOrder = orderController.selectedOrder.value;

    if (selectedOrder == null) {
      return Scaffold(
        appBar: AppBar(
            title: const Text('Order Details')),
        body: const Center(child: Text('No order selected.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${selectedOrder.id}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Address: ${selectedOrder.address}'),
            const SizedBox(height: 8),
            Text('Payment Method: ${selectedOrder.paymentMethod}'),
            const SizedBox(height: 8),
            Text(
                'Total Amount: \$${selectedOrder.totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text('Order Items:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: selectedOrder.orderDetails.length,
                itemBuilder: (context, index) {
                  final item = selectedOrder.orderDetails[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${item.quantity}x'),
                      ),
                      title: Text(item.title),
                      subtitle:
                          Text('Price: \$${item.price.toStringAsFixed(2)}'),
                      trailing: Text(
                          'Subtotal: \$${(item.quantity * item.price).toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
