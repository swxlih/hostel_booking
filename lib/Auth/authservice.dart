import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hostel_booking/BottomNavBar/bottomnavbar.dart';
import 'package:hostel_booking/Homepage/homepage.dart';
import 'package:hostel_booking/Login/loginpage.dart';
import 'package:hostel_booking/Model/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;



  Future<String> signup({
    required Usermodel data,
    required String password,
  }) async {
    String res = "some error occurs";
    if (data.email!.isNotEmpty && password.isNotEmpty) {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: data.email ?? 'N/A',
        password: password,
      );
      await _firestore.collection("User").doc(credential.user!.uid).set({
        'name': data.name,
        'phonenumber': data.number,
        "role": data.role,
        "address": data.address,
        'uid': credential.user!.uid,
        'email': data.email,
      });
      res = "success";
      
    } else {
      res = 'please fill all the fields';
    }
    try {} catch (err) {
      return err.toString();
    }
    return res;
  }

 Future<String?> login({
  required String email,
  required String password,
  }) async {
  try {
    UserCredential credential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final userDoc = await _firestore
        .collection("User")
        .doc(uid)
        .get();

    if (!userDoc.exists) {
      return "User data not found";
    }

    final role = userDoc['role'];

    // Optional: store if you really need later
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("uid", uid);
    await prefs.setString("role", role);

    return role;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 'user-not-found';
    } else if (e.code == 'wrong-password') {
      return 'wrong-password';
    } else {
      return 'login-failed';
    }
  }
}

  Future<void> signout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
     if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage2()),
      (Route<dynamic> route) => false,
    );
  }
}