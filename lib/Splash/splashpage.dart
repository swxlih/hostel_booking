import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hostel_booking/BottomNavBar/bottomnavbar.dart';
import 'package:hostel_booking/Login/loginpage.dart';
import 'package:hostel_booking/vendor/bottomnav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    /// 1️⃣ Animation Setup
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    /// 2️⃣ Navigate after animation delay
    Future.delayed(const Duration(seconds: 3), _navigateAfterSplash);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateAfterSplash() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    String? role = prefs.getString("role");

    try {
      if (userId != null && userId.isNotEmpty) {
        if (role == "user") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ModernNavBar()),
          );
        } else if (role == "vendor") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Bottomnav()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage2()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage2()),
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEAA61),

      /// Smooth Animated Logo
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              "assets/images/hostaaimg.png",
              width: 250,
              height: 250,
            ),
          ),
        ),
      ),
    );
  }
}
