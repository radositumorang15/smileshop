import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart' as order_model; // Alias untuk model Order

class OrderController extends GetxController {
  var orders = <order_model.Order>[].obs;
  var selectedOrder = Rxn<order_model.Order>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

void fetchOrders() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    final snapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)  // Sort orders by 'createdAt' in descending order
        .get();

    orders.value = snapshot.docs.map((doc) {
      final data = doc.data();
      return order_model.Order(
        id: doc.id,
        userId: data['userId'],
        address: data['address'] ?? '',
        paymentMethod: data['paymentMethod'] ?? '',
        totalAmount: (data['totalAmount'] as num).toDouble(),
        createdAt: DateTime.parse(data['createdAt']),
        orderDetails: (data['orderDetails'] as List<dynamic>).map((detail) {
          return order_model.OrderDetail(
            productId: detail['productId'],
            title: detail['title'],
            quantity: detail['quantity'],
            price: (detail['price'] as num).toDouble(),
          );
        }).toList(),
      );
    }).toList();
  } catch (e) {
    Get.snackbar('Error', 'Failed to fetch orders: $e');
    print(e);
  }
}


  void selectOrder(order_model.Order order) {
    selectedOrder.value = order;
  }
}
