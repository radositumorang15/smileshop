import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product_detail_page.dart';
import 'cart_page.dart';
import 'login_page.dart';
import 'profile_page.dart';
import './my_orders_page.dart';
import './components/vertical_carousel.dart';
import './components/custom_bottom_navigation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

User? user = FirebaseAuth.instance.currentUser;
String get userEmail {
  if (user?.email != null) {
    // Mengambil bagian sebelum '@' dari email
    return user!.email!.split('@')[0];
  } else {
    return 'User';
  }
}

class _HomePageState extends State<HomePage> {
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  int _selectedIndex = 0;

  // List of pages for bottom navigation
  final List<Widget> _pages = [
    HomeContent(), // The existing home content
    MyOrdersPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      Get.offAll(() => LoginPage());
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 ? _buildHomeAppBar() : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  AppBar _buildHomeAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 80,
      title: Row(
        children: [
          Image.asset(
            'assets/logo.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello ${userEmail}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Notification Icon
        Stack(
          alignment: Alignment.topRight,
        ),
        // Cart Icon
        IconButton(
          icon: Icon(Icons.shopping_bag_outlined, color: Colors.black),
          onPressed: () {
            Get.to(() => CartPage());
          },
        ),
        // Logout Icon
        IconButton(
          icon: Icon(Icons.logout, color: Colors.black),
          onPressed: _logout,
        ),
      ],
    );
  }
}

class HomeContent extends StatelessWidget {
  final ProductController productController = Get.find();
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Carousel
          SizedBox(
            height: 160,
            child: VerticalCarousel(),
          ),
          // Product Grid
          Obx(() {
            if (productController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF059669)), // Menggunakan warna kustom
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: productController.productList.length,
                  itemBuilder: (context, index) {
                    var product = productController.productList[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // Product Image
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                product.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Name
                                Text(
                                  product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 5),
                                // Product Price
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Action Buttons
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Add to Cart Button
                                IconButton(
                                  icon: Icon(Icons.shopping_cart),
                                  color: Colors.teal,
                                  onPressed: () {
                                    cartController.addToCart(product);
                                    Get.snackbar(
                                      'Cart',
                                      '${product.title} has been added to cart!',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  },
                                ),
                                // View Details Button
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(ProductDetailPage(product: product));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Details',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(
                                          255, 225, 228, 227), // Warna teks
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
