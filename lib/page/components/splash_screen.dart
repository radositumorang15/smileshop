import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cart_app/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi animasi
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500), // Durasi animasi fade-in
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Mulai animasi
    _animationController.forward();

    // Tambahkan penundaan sebelum navigasi ke AuthWrapper
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => AuthWrapper()); // Navigasi ke AuthWrapper setelah penundaan
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // Bersihkan controller animasi
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/logo.png',
            width: 150,
          ),
        ),
      ),
    );
  }
}
