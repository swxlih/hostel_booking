import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FetchUserData {
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('booking')
          .doc(uid)
          .get();

      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
}