import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // Untuk mendeteksi platform
import 'package:Browniesbites/common/color_extension.dart';
import 'package:Browniesbites/common/extension.dart';
import 'package:Browniesbites/common_widget/round_button.dart';
import 'package:Browniesbites/view/login/login_view.dart';
import '../../common/globs.dart';
import '../../common_widget/round_textfield.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              Text(
                "Sign Up",
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
              Text(
                "Add your details to sign up",
                style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: "Name",
                controller: txtName,
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: "Email",
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: "Password",
                controller: txtPassword,
                obscureText: true,
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: "Confirm Password",
                controller: txtConfirmPassword,
                obscureText: true,
              ),
              const SizedBox(height: 25),
              RoundButton(title: "Sign Up", onPressed: () => btnSignUp()),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginView(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Already have an Account? ",
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                          color: TColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menangani tombol Sign Up
  void btnSignUp() {
    if (txtName.text.isEmpty) {
      mdShowAlert(Globs.appName, MSG.enterName, () {});
      return;
    }

    if (!txtEmail.text.isEmail) {
      mdShowAlert(Globs.appName, MSG.enterEmail, () {});
      return;
    }

    if (txtPassword.text.length < 6) {
      mdShowAlert(Globs.appName, MSG.enterPassword, () {});
      return;
    }

    if (txtPassword.text != txtConfirmPassword.text) {
      mdShowAlert(Globs.appName, MSG.enterPasswordNotMatch, () {});
      return;
    }

    endEditing();

    // Panggil fungsi Sign Up
    serviceCallSignUp({
      "name": txtName.text,
      "email": txtEmail.text,
      "password": txtPassword.text,
      "push_token": "",
      "device_type": detectPlatform()
    });
  }

  // Fungsi untuk mendeteksi platform
  String detectPlatform() {
    if (kIsWeb) {
      return "W"; // Platform Web
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return "A"; // Platform Android
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return "I"; // Platform iOS
    }
    return "U"; // Platform Unknown
  }

  // Fungsi Sign-Up menggunakan Firebase
  void serviceCallSignUp(Map<String, String> userData) async {
    try {
      // Menampilkan loading
      showLoading();

      // Firebase Authentication untuk sign-up
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userData['email']!,
        password: userData['password']!,
      );

      // Berhasil
      hideLoading();
      mdShowAlert(Globs.appName, "Sign-Up Successful", () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      });
    } on FirebaseAuthException catch (e) {
      hideLoading();
      mdShowAlert("Error", e.message ?? "An error occurred", () {});
    }
  }

  // Fungsi untuk menampilkan dan menyembunyikan loading
  void showLoading() {
    // Implementasikan loading sesuai kebutuhan
    print("Show loading...");
  }

  void hideLoading() {
    // Implementasikan hide loading
    print("Hide loading...");
  }
}
