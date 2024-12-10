class Order {
  final String id;
  final String userId;
  final String address;
  final String paymentMethod;
  final double totalAmount;
  final List<OrderDetail> orderDetails;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.address,
    required this.paymentMethod,
    required this.totalAmount,
    required this.orderDetails,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'address': address,
      'paymentMethod': paymentMethod,
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'orderDetails': orderDetails.map((detail) => detail.toJson()).toList(),
    };
  }
}

class OrderDetail {
  final int productId;
  final String title;
  final int quantity;
  final double price;

  OrderDetail({
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'quantity': quantity,
      'price': price,
    };
  }
}
