import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_booking/Auth/authservice.dart';
import 'package:hostel_booking/Signup/signuppage.dart';
import 'package:hostel_booking/BottomNavBar/bottomnavbar.dart';
import 'package:hostel_booking/Splash/splashpage.dart';
import 'package:hostel_booking/vendor/bottomnav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage2 extends StatefulWidget {
  const LoginPage2({super.key});

  @override
  State<LoginPage2> createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final AuthService _auth = AuthService();

  bool isLoading = false;
  bool hidePassword = true;

  Future<void> saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
  }

 Future<void> login() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => isLoading = true);

  final role = await _auth.login(
    email: _email.text.trim(),
    password: _password.text.trim(),
  );

  setState(() => isLoading = false);

  if (!mounted) return;

  if (role == 'user') {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => ModernNavBar()),
      (_) => false,
    );
  } else if (role == 'vendor') {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Bottomnav()),
      (_) => false,
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login failed")),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FF),
      body: Stack(
        children: [
          /// TOP BACKGROUND CURVE
          ClipPath(
            clipper: CurveClipper(),
            child: Container(
              height: 280.h,
              width: double.infinity,
              color: const Color(0xffFEAA61),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/hostaaimg.png",height: 260,width: 260,)
                ],
              ),
            ),
          ),

          /// LOGIN CARD
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 80.h),
                child: Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          "Welcome Back!",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "Login to continue your hostel booking",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 30.h),

                        /// EMAIL FIELD
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(fontSize: 14.sp),
                            prefixIcon: Icon(Icons.email_outlined, size: 22.sp),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          style: TextStyle(fontSize: 14.sp),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter your email";
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                .hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),

                        /// PASSWORD FIELD
                        TextFormField(
                          controller: _password,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(fontSize: 14.sp),
                            prefixIcon: Icon(Icons.lock_outline, size: 22.sp),
                            suffixIcon: IconButton(
                              icon: Icon(
                                hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 22.sp,
                              ),
                              onPressed: () =>
                                  setState(() => hidePassword = !hidePassword),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          style: TextStyle(fontSize: 14.sp),
                          validator: (value) {
                            if (value!.isEmpty) return "Enter your password";
                            if (value.length < 8) {
                              return "Password must be at least 8 characters";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 10.h),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: TextButton(
                        //     onPressed: () {},
                        //     child: Text(
                        //       "Forgot Password?",
                        //       style: TextStyle(fontSize: 14.sp),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 20.h),

                        /// LOGIN BUTTON
                        isLoading
                            ? CircularProgressIndicator(color: Colors.lightBlue)
                            : SizedBox(
                                width: double.infinity,
                                height: 50.h,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffFEAA61),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  onPressed: login,
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),

                        SizedBox(height: 25.h),

                        /// REGISTER LINK
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "New to Hostel Hub?",
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage()),
                                );
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// CURVED CLIPPER
class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80.h);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 80.h,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
