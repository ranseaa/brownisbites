import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Browniesbites/common/color_extension.dart';
import 'package:Browniesbites/common/extension.dart';
import 'package:Browniesbites/common_widget/round_button.dart';
import 'package:Browniesbites/view/login/rest_password_view.dart';
import 'package:Browniesbites/view/login/sing_up_view.dart';
import 'package:Browniesbites/view/on_boarding/on_boarding_view.dart';

import '../../common/globs.dart';
import '../../common_widget/round_icon_button.dart';
import '../../common_widget/round_textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

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
                "Login",
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
              Text(
                "Add your details to login",
                style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: "Your Email",
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
              RoundButton(
                  title: "Login",
                  onPressed: () {
                    btnLogin();
                  }),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPasswordView(),
                    ),
                  );
                },
                child: Text(
                  "Forgot your password?",
                  style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "or Login With",
                style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
              RoundIconButton(
                icon: "assets/img/facebook_logo.png",
                title: "Login with Facebook",
                color: const Color(0xff367FC0),
                onPressed: () {},
              ),
              const SizedBox(height: 25),
              RoundIconButton(
                icon: "assets/img/google_logo.png",
                title: "Login with Google",
                color: const Color(0xffDD4B39),
                onPressed: () {},
              ),
              const SizedBox(height: 80),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpView(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don't have an Account? ",
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Sign Up",
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

  // Fungsi untuk login menggunakan Firebase Authentication
  void btnLogin() async {
    if (!txtEmail.text.isEmail) {
      mdShowAlert(Globs.appName, MSG.enterEmail, () {});
      return;
    }

    if (txtPassword.text.isEmpty) {
      mdShowAlert(Globs.appName, MSG.enterPassword, () {});
      return;
    }

    // Menutup keyboard
    endEditing();

    // Panggil fungsi Firebase Authentication untuk login
    serviceCallLogin({
      "email": txtEmail.text,
      "password": txtPassword.text,
    });
  }

  void serviceCallLogin(Map<String, String> userData) async {
    try {
      // Tampilkan loading indicator
      showLoading();

      // Firebase Authentication untuk login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userData['email']!,
        password: userData['password']!,
      );

      // Jika berhasil, navigasi ke halaman berikutnya
      hideLoading();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const OnBoardingView(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      hideLoading();

      // Tangani error saat login
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "User not found. Please sign up.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address.";
          break;
        default:
          errorMessage = e.message ?? "An unknown error occurred.";
      }

      mdShowAlert("Login Error", errorMessage, () {});
    }
  }

  // Fungsi untuk menampilkan dan menyembunyikan loading
  void showLoading() {
    print("Show loading...");
    Globs.showHUD();
  }

  void hideLoading() {
    print("Hide loading...");
    Globs.hideHUD();
  }
}
