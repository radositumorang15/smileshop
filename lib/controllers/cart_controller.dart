import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
// Import your order_model with an alias
import '/controllers/order_controller.dart';
import '../models/order_model.dart' as order_model;

class CartController extends GetxController {
  var cartItems = <Product>[].obs;
  var isLoading = false.obs;
  var address = ''.obs; // Alamat pengiriman
  var paymentMethod = 'PayPal'.obs; // Metode pembayaran default
  var shippingMethod = 'Standard'.obs; // Metode pengiriman default

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get userId {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'Pengguna tidak terautentikasi');
      return '';
    }
    return user.uid;
  }

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchCartFromFirestore();
      } else {
        clearCart();
      }
    });
  }

  void updateAddress(String value) => address.value = value;
  void updatePaymentMethod(String method) => paymentMethod.value = method;
  void updateShippingMethod(String method) => shippingMethod.value = method;

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.price * (item.quantity ?? 1)));

  double get shippingCost => shippingMethod.value == 'Express' ? 12.0 : 10.0;
  double get totalWithShipping => totalPrice + shippingCost;
  int get totalItems => cartItems.fold(0, (sum, item) => sum + (item.quantity ?? 1));

  Future<void> addToCart(Product product) async {
    if (userId.isEmpty) {
      Get.snackbar('Error', 'Silakan login terlebih dahulu');
      return;
    }

    try {
      isLoading(true);
      final docRef = _firestore
          .collection('carts')
          .doc(userId)
          .collection('items')
          .doc(product.id.toString());

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update({'quantity': FieldValue.increment(1)});
      } else {
        await docRef.set({
          'title': product.title,
          'price': product.price,
          'image': product.image,
          'quantity': 1,
        });
      }

      final existingIndex = cartItems.indexWhere((item) => item.id == product.id);
      if (existingIndex != -1) {
        cartItems[existingIndex] = product.copyWith(
          quantity: (cartItems[existingIndex].quantity ?? 0) + 1,
        );
      } else {
        cartItems.add(product.copyWith(quantity: 1));
      }

      Get.snackbar('Sukses', 'Produk ditambahkan ke keranjang');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan ke keranjang: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> removeFromCart(Product product) async {
    if (userId.isEmpty) {
      Get.snackbar('Error', 'Silakan login terlebih dahulu');
      return;
    }

    try {
      isLoading(true);
      await _firestore
          .collection('carts')
          .doc(userId)
          .collection('items')
          .doc(product.id.toString())
          .delete();

      cartItems.removeWhere((item) => item.id == product.id);
      Get.snackbar('Sukses', 'Produk dihapus dari keranjang');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus dari keranjang: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateQuantity(Product product, int quantity) async {
    if (userId.isEmpty) {
      Get.snackbar('Error', 'Silakan login terlebih dahulu');
      return;
    }

    try {
      isLoading(true);
      final docRef = _firestore
          .collection('carts')
          .doc(userId)
          .collection('items')
          .doc(product.id.toString());

      if (quantity <= 0) {
        await docRef.delete();
        cartItems.removeWhere((item) => item.id == product.id);
      } else {
        await docRef.update({'quantity': quantity});

        final index = cartItems.indexWhere((item) => item.id == product.id);
        if (index != -1) {
          cartItems[index] = product.copyWith(quantity: quantity);
        }
      }

      Get.snackbar('Sukses', 'Kuantitas diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui kuantitas: $e');
    } finally {
      isLoading(false);
    }
  }

Future<void> placeOrder(String address) async {
  if (userId.isEmpty) {
    Get.snackbar('Error', 'Silakan login terlebih dahulu');
    return;
  }

  if (cartItems.isEmpty) {
    Get.snackbar('Error', 'Keranjang belanja kosong');
    return;
  }

  try {
    isLoading(true);
    final orderId = _firestore.collection('orders').doc().id;

    final orderDetails = cartItems.map((item) {
      return order_model.OrderDetail(
        productId: item.id,
        title: item.title,
        quantity: item.quantity ?? 1,
        price: item.price,
      );
    }).toList();

    final order = order_model.Order(
      id: orderId,
      userId: userId,
      address: address,
      paymentMethod: paymentMethod.value,
      totalAmount: totalWithShipping,
      orderDetails: orderDetails,
      createdAt: DateTime.now(),
    );

    // Simpan order ke Firestore
    await _firestore.collection('orders').doc(orderId).set(order.toJson());

    // Hapus semua item di keranjang dari Firestore
    final cartItemsRef = _firestore.collection('carts').doc(userId).collection('items');
    final batch = _firestore.batch();

    final cartItemsSnapshot = await cartItemsRef.get();
    for (var doc in cartItemsSnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit(); // Hapus semua dokumen keranjang secara bersamaan

    clearCart(); // Bersihkan data lokal
    Get.snackbar('Sukses', 'Order berhasil dibuat dan keranjang dikosongkan');

    // Refresh orders in the OrderController
    final orderController = Get.find<OrderController>();
    orderController.fetchOrders();  // Refresh orders to reflect the new order
  } catch (e) {
    Get.snackbar('Error', 'Gagal membuat order: $e');
  } finally {
    isLoading(false);
  }
}


  Future<void> _fetchCartFromFirestore() async {
    if (userId.isEmpty) return;

    try {
      isLoading(true);
      final snapshot = await _firestore
          .collection('carts')
          .doc(userId)
          .collection('items')
          .get();

      final fetchedItems = snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: int.parse(doc.id),
          title: data['title'],
          price: data['price'].toDouble(),
          description: '',
          image: data['image'],
          quantity: data['quantity'] ?? 1,
        );
      }).toList();

      cartItems.assignAll(fetchedItems);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat keranjang: $e');
    } finally {
      isLoading(false);
    }
  }

  void clearCart() => cartItems.clear();
}
