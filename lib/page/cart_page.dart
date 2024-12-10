import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Keranjang belanja kosong',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // My Cart Section
              const Text(
                'My Cart',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  var product = cartController.cartItems[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      product.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.green),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
                                if (product.quantity! > 1) {
                                  cartController.updateQuantity(
                                    product,
                                    product.quantity! - 1,
                                  );
                                } else {
                                  cartController.removeFromCart(product);
                                }
                              },
                            ),
                            Text('${product.quantity ?? 1}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle, color: Colors.green),
                              onPressed: () {
                                cartController.updateQuantity(
                                  product,
                                  (product.quantity ?? 1) + 1,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        cartController.removeFromCart(product);
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
              // Delivery Location
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.teal),
                title: const Text('Delivery Location'),
                subtitle: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your delivery address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address cannot be empty';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      cartController.updateAddress(value);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // Payment Method
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Payment Method:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: cartController.paymentMethod.value,
                    items: const [
                      DropdownMenuItem(
                        value: 'PayPal',
                        child: Text('PayPal'),
                      ),
                      DropdownMenuItem(
                        value: 'COD',
                        child: Text('Cash On Delivery'),
                      ),
                    ],
                    onChanged: (value) {
                      cartController.updatePaymentMethod(value!);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // Shipping Method
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shipping Method:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: cartController.shippingMethod.value,
                    items: const [
                      DropdownMenuItem(
                        value: 'Standard',
                        child: Text('Standard (\$10.00)'),
                      ),
                      DropdownMenuItem(
                        value: 'Express',
                        child: Text('Express (\$12.00)'),
                      ),
                    ],
                    onChanged: (value) {
                      cartController.updateShippingMethod(value!);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // Order Info Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subtotal: \$${cartController.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Shipping Cost: \$${cartController.shippingCost.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: \$${cartController.totalWithShipping.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              // Checkout Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: cartController.cartItems.isNotEmpty
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          cartController.placeOrder(cartController.address.value);
                        }
                      }
                    : null,
                child: Text(
                  'Checkout (\$${cartController.totalWithShipping.toStringAsFixed(2)})',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
