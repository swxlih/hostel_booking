import 'package:flutter/material.dart';
import 'package:hostel_booking/BookNow/booknow.dart';
import 'package:hostel_booking/utils/helper/razorpay_service/razorpay.dart';
import 'package:hostel_booking/Bookingpage/bookinglist_screen.dart';
import 'package:hostel_booking/Favorites/favorites.dart';
import 'dart:ui';

import 'package:hostel_booking/Homepage/homepage.dart';
import 'package:hostel_booking/PgRooms/pgrooms.dart';
import 'package:hostel_booking/Profile/profile.dart';
import 'package:hostel_booking/vendor/home/vendor_home.dart';
import 'package:hostel_booking/vendor/home/bookings.dart';
import 'package:hostel_booking/vendor/home/vendor_profile.dart';



class Bottomnav extends StatefulWidget {
  const Bottomnav({Key? key}) : super(key: key);

  @override
  State<Bottomnav> createState() => bottomnavState();
}

class bottomnavState extends State<Bottomnav> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late List<AnimationController> _controllers;

  final List<NavItem> _navItems = [
    NavItem(
      icon: Icons.home_rounded,
      label: 'Home',
      gradient: const LinearGradient(
         colors: [Color(0xffFEAA61), Color.fromARGB(255, 236, 199, 167)],
      ),
    ),
     NavItem(
      icon: Icons.shopping_bag,
      label: 'Bookings',
      gradient: const LinearGradient(
         colors: [Color(0xffFEAA61),Color.fromARGB(255, 236, 199, 167)],
      ),
    ),
    
    NavItem(
      icon: Icons.person_rounded,
      label: 'Profile',
      gradient: const LinearGradient(
         colors: [Color(0xffFEAA61),Color.fromARGB(255, 236, 199, 167)],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _navItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );
    _controllers[0].forward();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _controllers[_selectedIndex].reverse();
      _controllers[index].forward();
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBody: true,
      body: _buildBody(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_navItems.length, (index) {
                  return _buildNavItem(index);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            final animation = CurvedAnimation(
              parent: _controllers[index],
              curve: Curves.easeInOutCubic,
            );

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Animated background circle
                      Transform.scale(
                        scale: animation.value,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: item.gradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: item.gradient.colors.first.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Icon
                      Transform.scale(
                        scale: 1.0 + (animation.value * 0.1),
                        child: Icon(
                          item.icon,
                          color: isSelected ? Colors.white : Colors.grey[600],
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Label with animation
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: isSelected ? 12 : 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? item.gradient.colors.first
                          : Colors.grey[600],
                    ),
                    child: Text(item.label),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _selectedIndex,
      children:
      [
        Adminhome(),
        Bookings(),
        Person(),

      ]);
  }

  Widget _buildPage(String title, IconData icon, Gradient gradient) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF8F9FA),
            gradient.colors.first.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  gradient: gradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              ShaderMask(
                shaderCallback: (bounds) => gradient.createShader(bounds),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Welcome to $title',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final Gradient gradient;

  NavItem({
    required this.icon,
    required this.label,
    required this.gradient,
  });
}