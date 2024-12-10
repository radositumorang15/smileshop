import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_page.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validasi input
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap isi email dan password')),
      );
      return;
    }

    try {
      // Firebase Authentication login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Login berhasil, simpan status login
      _onLoginSuccess();
    } on FirebaseAuthException catch (e) {
      // Tampilkan pesan kesalahan login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: ${e.message}')),
      );
    }
  }

  void _onLoginSuccess() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); // Tandai user sudah login
    Get.offAll(() => HomePage()); // Navigasi ke HomePage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(
                        0xFF059669), // Set the color when the TextField is focused
                    width:
                        2.0, // Optional: Adjust the width of the border when focused
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors
                        .grey, // Set the color when the TextField is not focused
                    width:
                        2.0, // Optional: Adjust the width of the border when not focused
                  ),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),

            // Input password
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(
                        0xFF059669), // Set the color when the TextField is focused
                    width:
                        2.0, // Optional: Adjust the width of the border when focused
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors
                        .grey, // Set the color when the TextField is not focused
                    width:
                        2.0, // Optional: Adjust the width of the border when not focused
                  ),
                ),
              ),
              obscureText: true, // Hides the text input (for passwords)
            ),
            SizedBox(height: 20),

            // Tombol login
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color(0xFF009B77), // Set the background color to white
                foregroundColor:
                    Color.fromARGB(255, 222, 228, 227), // Set the text color to the green color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8.0), // Set the border radius
                  side: BorderSide(
                      color: Color(0xFF009B77)), // Add a green border
                ),
              ),
            ),

            // Tombol navigasi ke halaman signup
            TextButton(
              onPressed: () {
                Get.to(SignupPage());
              },
              child: Text(
                'Belum punya akun? Daftar di sini',
                style: TextStyle(
                  color: Color(
                      0xFF059669), // Replace with your desired color (e.g., #059669)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
