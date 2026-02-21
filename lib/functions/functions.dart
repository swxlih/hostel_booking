import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_booking/Login/loginpage.dart';

class Fetchuserdata {

  Future<Map<String, dynamic>?> getUserData(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _logoutAndRedirect(context);
        return null;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(user.uid)
          .get();

      // 🔴 If document does NOT exist or data is null
      if (!userDoc.exists || userDoc.data() == null) {
        _logoutAndRedirect(context);
        return null;
      }

      return userDoc.data() as Map<String, dynamic>;
    } catch (e) {
      _logoutAndRedirect(context);
      return null;
    }
  }

  void _logoutAndRedirect(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage2()),
      (route) => false,
    );
  }
}
