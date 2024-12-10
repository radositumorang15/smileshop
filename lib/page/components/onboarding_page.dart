import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../login_page.dart';
import '../signup_page.dart';

class OnboardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/onboard.png', width: 300),
                SizedBox(height: 30),
                Text(
                  'Selamat datang di SmilShop!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Nikmati Pengalaman belanja yang menyenangkan dengan harga terjangkau!',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(LoginPage());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF009B77), // Set the background color
                    foregroundColor: Color.fromARGB(255, 251, 253, 252), 
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Set the border radius
                    ),
                  ),
                  child: Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(SignupPage());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFFFFFFFF), // Set the background color to white
                    foregroundColor: Color(
                        0xFF009B77), // Set the text color to the green color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Set the border radius
                      side: BorderSide(
                          color: Color(0xFF009B77)), // Add a green border
                    ),
                  ),
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
